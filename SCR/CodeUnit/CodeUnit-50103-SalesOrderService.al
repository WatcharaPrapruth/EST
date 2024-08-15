codeunit 50103 "EST Sales invoice service"
{
    var
        apiMgt: Codeunit "EST API Management YVS";
        isNull: Label '%1 must have a value in %2. It cannot be zero or empty.';
        Sales_Invoice_Header: Label 'Sales Invoice Header';
        Seles_Invoice_Line: Label 'Sales Invoice Line';
        //Header
        SalesInvoice_No: Label 'SalesInvoice_No';
        Document_date: Label 'Document_date';
        Customer_No: Label 'Customer_No';
        Customer_Name: Label 'Customer_Name';
        Address: Label 'Address';
        Address2: Label 'Address2';
        City: Label 'City';
        Phone_No: Label 'Phone_No';
        Shipping_Agent: Label 'Shipping_Agent';
        Route_Name: Label 'Route_Name';
        Duedate: Label 'Duedate';
        Department: Label 'Department';
        Payment_term: Label 'Payment_term';
        Remark: Label 'Remark';
        Order_No: Label 'Order_No';
        Shipment_Date: Label 'Shipment_Date';
        External_Document_No: Label 'External_Document_No';
        Approver_Name: Label 'Approver_Name';
        Sales_Area: Label 'Salesarea';
        Salesperson: Label 'Salesperson';
        SalespersonName: Label 'Salesperson_Name';
        SumQty: Label 'SumQty';
        VAT_No: Label 'VAT_No';
        VAT_Branch: Label 'VAT_Branch';
        TotalAmount: Label 'TotalAmount';
        AmountBeforeVAT: Label 'AmountBeforeVAT';
        VATAmount: Label 'VATAmount';
        Lines: Label 'Lines';

        //Line
        LineNum: Label 'LineNum';
        Item_number: Label 'Item_number';
        Item_quantity: Label 'Item_quantity';
        Unit_Price: Label 'Unit_Price';
        Percent_discount_1: Label 'Percent_discount_1';
        Percent_discount_2: Label 'Percent_discount_2';
        Line_discount_amount: Label 'Line_discount_amount';
        LineAmount: Label 'LineAmount';
        Total_discount_per_line: Label 'Total_discount_per_line';
        Unit_of_measure: Label 'Unit_of_measure';
        VAT_Rate: Label 'VAT_Rate';
        Company: Label 'Company';
        Base_Qty: Label 'Base_Qty';
        Location: Label 'Location';
        Bin: Label 'Bin';
        Item_description: Label 'Item_description';
        Floor_location: Label 'Floor_location';
        Delivery_name: Label 'Delivery_name';
        Delivery_address: Label 'Delivery_address';
        Amount: Label 'Amount';
        IsDeposit: Label 'IsDeposit';
        Costcenter: Label 'Costcenter';
        PurchaseDate: Label 'PurchaseDate';

    procedure process(var salesInvoidHeader: Record "Sales Invoice Header")
    var
        JsonObject: JsonObject;
        JResObj: JsonObject;
        JResArr: JsonArray;
        JResponse: JsonObject;

        Response: Text;
        ActionPage: Enum "EST Action Page";
        MethodType: Enum "EST Method Type";
        Direction: Enum "EST Direction";
        StatusInterface: Enum "EST Status Interface";
        BC_Entry_Ref: Integer;
        Key1: text;
        Key2: Text;
        JsonRes_log: Text;

    begin
        JsonObject := CreateJsonSalesInvoice(salesInvoidHeader);

        Key1 := apiMgt.GetJsonToken(JsonObject, SalesInvoice_No).AsValue().AsCode();
        Key2 := apiMgt.GetJsonToken(JsonObject, Customer_No).AsValue().AsCode();

        // JResObj.Add('PrimaryKeyValue1', Key1);
        // JResObj.Add('PrimaryKeyValue2', Key2);

        if SendSalesInvoice(JsonObject, Response) then begin

            // JResArr.Add(JResObj);
            // JResponse.Add('Key_ID', JResArr);
            // JResponse.Add('Status', Format(StatusInterface::Success));
            // JResponse.Add('Remark', Response);
            // JResponse.WriteTo(JsonRes_log);
            apiMgt.UpdateSalesInvoiceHeadAPIComplete(salesInvoidHeader, true);
            apiMgt.InsertAPILog(ActionPage::"Sales Order", MethodType::Insert, Direction::Outbound,
                        Format(JsonObject), Response, StatusInterface::Success,
                        Key1, Key2,
                        '', BC_Entry_Ref);
        end
        else begin

            // JResArr.Add(JResObj);
            // JResponse.Add('Key_ID', JResArr);
            // JResponse.Add('Status', Format(StatusInterface::Failed));
            // JResponse.Add('Remark', Response);
            // JResponse.WriteTo(JsonRes_log);
            apiMgt.UpdateSalesInvoiceHeadAPIComplete(salesInvoidHeader, false);
            apiMgt.InsertAPILog(ActionPage::"Sales Order", MethodType::Insert, Direction::Outbound,
                        Format(JsonObject), Response, StatusInterface::Failed,
                        Key1, Key2,
                        GetLastErrorText(), BC_Entry_Ref);
            Error(GetLastErrorText());

        end;
    end;

    [TryFunction]
    procedure SendSalesInvoice(var JsonObject: JsonObject; var Response: Text)
    var
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;

        ContentHeaders: HttpHeaders;
        HttpContent: HttpContent;

        JsonText: Text;
        //Response: Text;
        AuthString: Text;
        Base64Convert: Codeunit "Base64 Convert";

        setUp: Record "Sales & Receivables Setup";
        url: Text[250];
        username: Text[50];
        password: Text[150];
        method: Text[15];
    begin
        //validate(JsonObject);
        JsonText := Format(JsonObject);
        if setUp.FindFirst then begin
            url := setUp."EST Sales Interface Path";
            username := setUp."EST SI Username";
            password := setUp."EST SI Password";
            method := setUp."EST SI Method";

            RequestMessage.SetRequestUri(url);
            RequestMessage.Method(method);
            RequestMessage.GetHeaders(RequestHeaders);
            AuthString := STRSUBSTNO('%1:%2', username, password);
            AuthString := Base64Convert.ToBase64(AuthString);
            AuthString := STRSUBSTNO('Basic %1', AuthString);
            RequestHeaders.Add('Authorization', AuthString);

            HttpContent.WriteFrom(JsonText);
            HttpContent.GetHeaders(ContentHeaders);
            ContentHeaders.Remove('Content-Type');
            ContentHeaders.Add('Content-Type', 'application/json');
            HttpContent.GetHeaders(ContentHeaders);
            RequestMessage.Content(HttpContent);

            if HttpClient.Send(RequestMessage, ResponseMessage) then begin
                ResponseMessage.Content.ReadAs(Response);

                if not ResponseMessage.IsSuccessStatusCode then
                    Error(Response);
            end;
        end;
    end;

    procedure validate(var JsonObject: JsonObject)
    var
        myInt: Integer;
    begin
        validateHeader(JsonObject);
        validateLine(JsonObject);
    end;

    local procedure validateHeader(var JsonObject: JsonObject)
    var
        myInt: Integer;
    begin
        if apiMgt.GetJsonToken(JsonObject, SalesInvoice_No).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, SalesInvoice_No, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Document_date).AsValue().AsDate() = 0D then
            Error(StrSubstNo(isNull, Document_date, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Customer_No).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Customer_No, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Customer_Name).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Customer_Name, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Address).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Address, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Address2).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Address2, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, City).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, City, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Shipping_Agent).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Shipping_Agent, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Route_Name).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Route_Name, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Duedate).AsValue().AsDate() = 0D then
            Error(StrSubstNo(isNull, Duedate, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Payment_term).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Payment_term, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Order_No).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Order_No, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Shipment_Date).AsValue().AsDate() = 0D then
            Error(StrSubstNo(isNull, Shipment_Date, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, External_Document_No).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, External_Document_No, Sales_Invoice_Header));

        // if apiMgt.GetJsonToken(JsonObject, Approver_Name).AsValue().AsText() = '' then
        //     Error(StrSubstNo(isNull, Approver_Name, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Sales_Area).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Sales_Area, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, Salesperson).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, Salesperson, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, SalespersonName).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, SalespersonName, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, SalespersonName).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, SalespersonName, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, SumQty).AsValue().AsDecimal() = 0 then
            Error(StrSubstNo(isNull, SumQty, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, VAT_No).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, VAT_No, Sales_Invoice_Header));

        if apiMgt.GetJsonToken(JsonObject, VAT_Branch).AsValue().AsText() = '' then
            Error(StrSubstNo(isNull, VAT_Branch, Sales_Invoice_Header));

        // if apiMgt.GetJsonToken(JsonObject, TotalAmount).AsValue().AsDecimal() = 0 then
        //     Error(StrSubstNo(isNull, TotalAmount, Sales_Invoice_Header));

        // if apiMgt.GetJsonToken(JsonObject, AmountBeforeVAT).AsValue().AsDecimal() = 0 then
        //     Error(StrSubstNo(isNull, AmountBeforeVAT, Sales_Invoice_Header));

        // if apiMgt.GetJsonToken(JsonObject, VATAmount).AsValue().AsDecimal() = 0 then
        //     Error(StrSubstNo(isNull, VATAmount, Sales_Invoice_Header));

    end;

    local procedure validateLine(var JsonObject: JsonObject)
    var
        JSaleInvoiceLinesToken: JsonToken;
        JSaleInvoiceLineToken: JsonToken;
        JSaleInvoiceLineArray: JsonArray;
        JSaleInvoiceLine: JsonObject;
    begin
        if JsonObject.Get(Lines, JSaleInvoiceLinesToken) then begin
            JSaleInvoiceLineArray := JSaleInvoiceLinesToken.AsArray();
            foreach JSaleInvoiceLineToken in JSaleInvoiceLineArray do begin
                JSaleInvoiceLine := JSaleInvoiceLineToken.AsObject();

                if apiMgt.GetJsonToken(JSaleInvoiceLine, LineNum).AsValue().AsInteger() = 0 then
                    Error(StrSubstNo(isNull, LineNum, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Item_number).AsValue().AsCode() = '' then
                    Error(StrSubstNo(isNull, Item_number, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Item_quantity).AsValue().AsDecimal() = 0 then
                    Error(StrSubstNo(isNull, Item_quantity, Seles_Invoice_Line));

                // if apiMgt.GetJsonToken(JSaleInvoiceLine, Unit_Price).AsValue().AsDecimal() = 0 then
                //     Error(StrSubstNo(isNull, Unit_Price, Seles_Invoice_Line));

                // if apiMgt.GetJsonToken(JSaleInvoiceLine, LineAmount).AsValue().AsDecimal() = 0 then
                //     Error(StrSubstNo(isNull, LineAmount, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Unit_of_measure).AsValue().AsCode() = '' then
                    Error(StrSubstNo(isNull, Unit_of_measure, Seles_Invoice_Line));

                // if apiMgt.GetJsonToken(JSaleInvoiceLine, VAT_Rate).AsValue().AsDecimal() = 0 then
                //     Error(StrSubstNo(isNull, VAT_Rate, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Company).AsValue().AsText() = '' then
                    Error(StrSubstNo(isNull, Company, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Location).AsValue().AsCode() = '' then
                    Error(StrSubstNo(isNull, Location, Seles_Invoice_Line));

                // if apiMgt.GetJsonToken(JSaleInvoiceLine, Bin).AsValue().AsCode() = '' then
                //     Error(StrSubstNo(isNull, Bin, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Item_description).AsValue().AsText() = '' then
                    Error(StrSubstNo(isNull, Item_description, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Floor_location).AsValue().AsCode() = '' then
                    Error(StrSubstNo(isNull, Floor_location, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Delivery_name).AsValue().AsText() = '' then
                    Error(StrSubstNo(isNull, Delivery_name, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, Delivery_address).AsValue().AsText() = '' then
                    Error(StrSubstNo(isNull, Delivery_address, Seles_Invoice_Line));

                // if apiMgt.GetJsonToken(JSaleInvoiceLine, Amount).AsValue().AsDecimal() = 0 then
                //     Error(StrSubstNo(isNull, Amount, Seles_Invoice_Line));

                if apiMgt.GetJsonToken(JSaleInvoiceLine, PurchaseDate).AsValue().AsDate() = 0D then
                    Error(StrSubstNo(isNull, PurchaseDate, Seles_Invoice_Line));

            end;
        end;

    end;

    procedure CreateJsonSalesInvoice(var salesInvoidHeader: Record "Sales Invoice Header"): JsonObject
    var
        outPutText: Text;

        HeaderJsonObject: JsonObject;
        LineJsonObject: JsonObject;
        JsonArray: JsonArray;

        IncVATAmount: Decimal;
        InvoiceDiscountAmountExclVAT: Decimal;
        TotalAmountExclVAT: Decimal;

    begin
        InitJsonSalesInvoiceHeader(salesInvoidHeader, HeaderJsonObject, IncVATAmount, InvoiceDiscountAmountExclVAT, TotalAmountExclVAT);
        InitJsonSalesInvoiceLine(salesInvoidHeader, JsonArray, IncVATAmount, InvoiceDiscountAmountExclVAT, TotalAmountExclVAT);

        HeaderJsonObject.Add(Lines, JsonArray);

        outPutText := Format(HeaderJsonObject);

        //apiMgt.UpdateSalesInvoiceHeadAPIComplete(salesInvoidHeader, true);

        exit(HeaderJsonObject);
    end;

    procedure InitJsonSalesInvoiceHeader(salesInvoidHeader: Record "Sales Invoice Header"; var HeaderJsonObject: JsonObject; var IncVATAmount: Decimal; var InvoiceDiscountAmountExclVAT: Decimal; var TotalAmountExclVAT: Decimal): JsonObject
    var
        TotalSalesInvoiceHeader: Record "Sales Invoice Header";
        salesInvoiceLine: Record "Sales Invoice Line";
        DocumentTotals: Codeunit "Document Totals";
        VATAmountInt: Decimal;
        DimMgt: Codeunit DimensionManagement;
        ShortDimCode: array[8] of Code[20];
    begin
        Clear(HeaderJsonObject);
        //HeaderJsonObject.Add('',salesInvoidHeader);
        HeaderJsonObject.Add(SalesInvoice_No, salesInvoidHeader."No.");
        HeaderJsonObject.Add(Document_date, salesInvoidHeader."Document Date");
        HeaderJsonObject.Add(Customer_No, salesInvoidHeader."Sell-to Customer No.");
        HeaderJsonObject.Add(Customer_Name, StrSubstNo('%1%2', salesInvoidHeader."Sell-to Customer Name", salesInvoidHeader."Sell-to Customer Name 2"));
        HeaderJsonObject.Add(Address, salesInvoidHeader."Sell-to Address");
        HeaderJsonObject.Add(Address2, salesInvoidHeader."Sell-to Address 2");
        HeaderJsonObject.Add(City, StrSubstNo('%1 %2', salesInvoidHeader."Sell-to City", salesInvoidHeader."Sell-to Post Code"));
        HeaderJsonObject.Add(Phone_No, salesInvoidHeader."Sell-to Phone No.");
        HeaderJsonObject.Add(Shipping_Agent, getShipAgent(salesInvoidHeader));//KT++
        HeaderJsonObject.Add(Route_Name, salesInvoidHeader."EST Route Name Description");//10
        HeaderJsonObject.Add(Duedate, salesInvoidHeader."Due Date");
        HeaderJsonObject.Add(Department, salesInvoidHeader."Shortcut Dimension 1 Code");//12
        HeaderJsonObject.Add(Payment_term, getPaymentTerm(salesInvoidHeader));
        HeaderJsonObject.Add(Remark, getRemark(salesInvoidHeader));//14
        HeaderJsonObject.Add(Order_No, salesInvoidHeader."Order No.");
        HeaderJsonObject.Add(Shipment_Date, salesInvoidHeader."Shipment Date");
        HeaderJsonObject.Add(External_Document_No, salesInvoidHeader."External Document No.");
        //KT ++
        DimMgt.GetShortcutDimensions(salesInvoidHeader."Dimension Set ID", ShortDimCode);
        HeaderJsonObject.Add(Approver_Name, getApproverName(salesInvoidHeader));//18
        HeaderJsonObject.Add(Sales_Area, ShortDimCode[3]);//19
        HeaderJsonObject.Add(Salesperson, salesInvoidHeader."Salesperson Code");
        HeaderJsonObject.Add(SalespersonName, getSalesperson(salesInvoidHeader));
        //KT --
        HeaderJsonObject.Add(SumQty, getSumQty(salesInvoidHeader));
        HeaderJsonObject.Add(VAT_No, salesInvoidHeader."VAT Registration No.");
        //KT ++
        if salesInvoidHeader."YVS Head Office" then
            HeaderJsonObject.Add(VAT_Branch, 'สำนักงานใหญ่')
        else
            HeaderJsonObject.Add(VAT_Branch, salesInvoidHeader."YVS VAT Branch Code");
        //KT --

        salesInvoiceLine.RESET;
        salesInvoiceLine.SETRANGE("Document No.", salesInvoidHeader."No.");
        salesInvoiceLine.SetRange(Type, "Sales Line Type"::Item);
        IF salesInvoiceLine.FIND('-') THEN begin
            DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader, VATAmountInt, salesInvoiceLine);
            HeaderJsonObject.Add(TotalAmount, TotalSalesInvoiceHeader."Amount Including VAT");
            IncVATAmount := TotalSalesInvoiceHeader."Amount Including VAT";
            InvoiceDiscountAmountExclVAT := TotalSalesInvoiceHeader."Invoice Discount Amount";
            TotalAmountExclVAT := TotalSalesInvoiceHeader.Amount;
            HeaderJsonObject.Add(AmountBeforeVAT, TotalSalesInvoiceHeader.Amount);
            HeaderJsonObject.Add(VATAmount, VATAmountInt);
        end;

        exit(HeaderJsonObject);
    end;

    procedure InitJsonSalesInvoiceLine(salesInvoidHeader: Record "Sales Invoice Header"; var JsonArray: JsonArray; var IncVATAmount: Decimal; var InvoiceDiscountAmountExclVAT: Decimal; var TotalAmountExclVAT: Decimal): JsonArray
    var
        salesInvoiceLine: Record "Sales Invoice Line";
        LineJsonObject: JsonObject;
    begin
        salesInvoiceLine.RESET;
        salesInvoiceLine.SETRANGE("Document No.", salesInvoidHeader."No.");
        salesInvoiceLine.SetRange(Type, "Sales Line Type"::Item);
        IF salesInvoiceLine.FIND('-') THEN
            REPEAT
                Clear(LineJsonObject);
                //LineJsonObject.Add('',salesInvoiceLine);
                LineJsonObject.Add(LineNum, salesInvoiceLine."Line No.");
                //LineJsonObject.Add('Type', Format(salesInvoiceLine.Type));
                LineJsonObject.Add(Item_number, salesInvoiceLine."No.");
                LineJsonObject.Add(Item_quantity, salesInvoiceLine.Quantity);
                //KT ++
                if salesInvoidHeader."EST Promotion Type" = "EST Promotion Type"::"Net Price" then begin
                    if salesInvoiceLine."EST Free Item" then
                        LineJsonObject.Add(Unit_Price, 0) //17                 
                    else
                        LineJsonObject.Add(Unit_Price, salesInvoiceLine."EST After Disc1"); //17
                    LineJsonObject.Add(Percent_discount_1, 0);//18
                end else begin
                    if salesInvoiceLine."EST Free Item" then
                        LineJsonObject.Add(Unit_Price, 0) //17
                    else
                        LineJsonObject.Add(Unit_Price, salesInvoiceLine."EST Standard Price"); //17
                    LineJsonObject.Add(Percent_discount_1, salesInvoiceLine."EST Standard Disc. %");//18
                end;
                LineJsonObject.Add(Percent_discount_2, salesInvoiceLine."EST Credit Disc. %");//19
                LineJsonObject.Add(Line_discount_amount, 0);//20 //KT+
                LineJsonObject.Add(LineAmount, salesInvoiceLine."Line Amount");//21
                //LineJsonObject.Add(Total_discount_per_line, salesInvoiceLine."Line Discount Amount");//22
                LineJsonObject.Add(Total_discount_per_line, InvoiceDiscountAmountExclVAT);//22
                //KT --
                LineJsonObject.Add(Unit_of_measure, salesInvoiceLine."Unit of Measure Code");
                LineJsonObject.Add(VAT_Rate, salesInvoiceLine."VAT %");
                LineJsonObject.Add(Company, 'EST');
                LineJsonObject.Add(Base_Qty, salesInvoiceLine."Quantity (Base)");
                LineJsonObject.Add(Location, salesInvoiceLine."Location Code");
                LineJsonObject.Add(Bin, salesInvoiceLine."Bin Code"); //KT++
                LineJsonObject.Add(Item_description, salesInvoiceLine.Description);
                //KT ++
                LineJsonObject.Add(Floor_location, salesInvoiceLine."EST Bin Pick");//30
                LineJsonObject.Add(Delivery_name, salesInvoidHeader."Ship-to Name" + salesInvoidHeader."Ship-to Name 2");
                LineJsonObject.Add(Delivery_address, StrSubstNo('%1%2 %3 %4',
                                                    salesInvoidHeader."Ship-to Address", salesInvoidHeader."Ship-to Address 2", salesInvoidHeader."Ship-to City", salesInvoidHeader."Ship-to Post Code"));
                //LineJsonObject.Add(Amount, IncVATAmount); //Keng
                LineJsonObject.Add(Amount, InvoiceDiscountAmountExclVAT + TotalAmountExclVAT); //Keng
                if salesInvoidHeader."EST Is Deposit" then
                    LineJsonObject.Add(IsDeposit, 1)
                else
                    LineJsonObject.Add(IsDeposit, 0);
                LineJsonObject.Add(Costcenter, 0);
                LineJsonObject.Add(PurchaseDate, salesInvoidHeader."EST PO Date");
                //KT --

                JsonArray.Add(LineJsonObject);

            UNTIL salesInvoiceLine.NEXT = 0;

    end;

    local procedure getPaymentTerm(salesInvoidHeader: Record "Sales Invoice Header"): Text[100]
    var
        paymentTerm: Record "Payment Terms";
    begin
        Clear(paymentTerm);
        if paymentTerm.GET(salesInvoidHeader."Payment Terms Code") then
            exit(paymentTerm.Description)
        else
            exit('');
    end;

    local procedure getRemark(salesInvoidHeader: Record "Sales Invoice Header") textTmp: Text
    var
        first: Boolean;
        salesCommentLine: Record "Sales Comment Line";
    begin
        textTmp := '';
        first := true;
        salesCommentLine.RESET;
        salesCommentLine.SETRANGE("Document Type", "Sales Comment Document Type"::"Posted Invoice");
        salesCommentLine.SETRANGE("No.", salesInvoidHeader."No.");
        IF salesCommentLine.FIND('-') THEN
            REPEAT
                if first then begin
                    textTmp := salesCommentLine.Comment;
                    first := false;
                end
                else begin
                    textTmp := StrSubstNo('%1, %2', textTmp, salesCommentLine.Comment);
                end;
            UNTIL salesCommentLine.NEXT = 0;
    end;

    local procedure getSalesperson(salesInvoidHeader: Record "Sales Invoice Header") textTmp: Text
    var
        salesPersonPurchaseer: Record "Salesperson/Purchaser";
    begin
        if salesPersonPurchaseer.GET(salesInvoidHeader."Salesperson Code") then
            textTmp := salesPersonPurchaseer.Name
    end;

    local procedure getSumQty(salesInvoidHeader: Record "Sales Invoice Header") Quantity: Decimal
    var
        salesInvoiceLine: Record "Sales Invoice Line";
    begin
        salesInvoiceLine.RESET;
        salesInvoiceLine.SETRANGE("Document No.", salesInvoidHeader."No.");
        salesInvoiceLine.CalcSums(Quantity);
        Quantity := salesInvoiceLine.Quantity;
    end;

    local procedure getApproverName(salesInvoidHeader: Record "Sales Invoice Header") approveName: Text
    var
        approveEntry: Record "Approval Entry";
        PstdApprovalEntry: Record "Posted Approval Entry";
        salesHeader: Record "Sales Header";
        user: Record User;
    begin
        Clear(PstdApprovalEntry);
        PstdApprovalEntry.SetCurrentKey("Table ID", "Document No.", Status, "Entry No.");
        PstdApprovalEntry.SETRANGE("Table ID", Database::"Sales Invoice Header");
        PstdApprovalEntry.SETRANGE("Document No.", salesInvoidHeader."No.");
        PstdApprovalEntry.SETRANGE(Status, "Approval Status"::Approved);
        PstdApprovalEntry.Ascending(false);
        PstdApprovalEntry.SetAscending("Entry No.", false);

        if PstdApprovalEntry.FindSet() then begin
            Clear(user);
            user.SetCurrentKey("User Name");
            user.SETRANGE("User Name", PstdApprovalEntry."Approver ID");
            if user.FindSet() then
                approveName := user."Full Name";
        end;
    end;

    local procedure getShipAgent(salesInvoidHeader: Record "Sales Invoice Header") textTmp: Text
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        if ShippingAgent.GET(salesInvoidHeader."Shipping Agent Code") then
            textTmp := ShippingAgent.Name;
    end;

}