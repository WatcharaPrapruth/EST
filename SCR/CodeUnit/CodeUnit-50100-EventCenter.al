codeunit 50100 "EST API EventFunction"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnInitRecordOnAfterAssignDates', '', false, false)]
    local procedure OnInitRecordOnAfterAssignDates(var PurchaseHeader: Record "Purchase Header")
    var
        type: Enum "EST For API Type";
        apiMgt: Codeunit "EST API Management YVS";
    begin
        type := "EST For API Type"::"For API PO";
        PurchaseHeader."EST For API PO" := apiMgt.GetForAPI(PurchaseHeader."No. Series", type);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidateReceivingNoSeries', '', false, false)]
    local procedure OnBeforeValidateReceivingNoSeries(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        type: Enum "EST For API Type";
        apiMgt: Codeunit "EST API Management YVS";
    begin
        type := "EST For API Type"::"For API PO";
        PurchaseHeader."EST For API PO" := apiMgt.GetForAPI(PurchaseHeader."No. Series", type);
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; WhseShip: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; InvtPickPutaway: Boolean)
    var
        type: Enum "EST For API Type";
        apiMgt: Codeunit "EST API Management YVS";
    begin
        type := "EST For API Type"::"For API SI";
        SalesInvHeader."EST For API SI" := apiMgt.GetForAPI(SalesInvHeader."No. Series", type);

        SalesInvHeader."EST Route Name" := SalesHeader."EST Route Name";
        SalesInvHeader."EST Route Name Description" := SalesHeader."EST Route Name Description";
        SalesInvHeader."EST Dimension Route Code" := SalesHeader."EST Dimension Route Code";
    end;
    //KT ++
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header";
                                           var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                                           var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                                           CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        siService: Codeunit "EST Sales invoice service";
    begin
        if SalesInvoiceHeader."EST For API SI" then begin
            siService.process(SalesInvoiceHeader);
        end;
    end;
    //KT --



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure OnAfterCopyFromItem(var SalesLine: Record "Sales Line"; Item: Record Item; CurrentFieldNo: Integer; xSalesLine: Record "Sales Line")
    var
        BinCtnt: Record "Bin Content";
    begin
        BinCtnt.Reset();
        BinCtnt.SetRange("Item No.", SalesLine."No.");
        BinCtnt.SetRange("EST Suggest Pick", true);
        if BinCtnt.FindFirst() then
            SalesLine."EST Bin Pick" := BinCtnt."Bin Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, true)]
    local procedure "OnAfterSubstituteReport"(ReportId: Integer; var NewReportId: Integer)
    begin

        if ReportId = Report::"Sales - Shipment" then
            NewReportId := report::"EST Sales - Shipment";

    end;
}