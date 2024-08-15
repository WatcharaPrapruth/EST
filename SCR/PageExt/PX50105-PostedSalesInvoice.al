pageextension 50105 "EST Posted Sales Invoice(YVS)" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("YVS Ref. Tax Invoice Amount")
        {
            field("EST For API SI"; Rec."EST For API SI")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the For API SI field.', Comment = '%';
            }
            field("EST API Completed"; Rec."EST API Completed")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the API Completed field.', Comment = '%';
            }
        }

        addbefore("Shipment Method Code")
        {

            field("EST Route Name"; Rec."EST Route Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Route Name field.', Comment = '%';
            }
            field("EST Route Name Description"; Rec."EST Route Name Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Route Name Description field.', Comment = '%';
            }
        }
        //KT ++
        addafter("Sell-to Customer Name")
        {
            field("EST Is Deposit"; Rec."EST Is Deposit")
            {
                ApplicationArea = All;
            }
        }
        addafter("External Document No.")
        {
            field("EST PO Date"; Rec."EST PO Date")
            {
                ApplicationArea = All;
            }
        }
        //KT --
    }

    actions
    {
        addafter("Category_Category5")
        {
            group("API Management")
            {
                Caption = 'API Management';
                actionref("For API Sales Invoices"; "For API Sales Invoice") { }
                actionref("Clear Sent APIs"; "Clear Sent API") { }
                actionref("Send API Sales Invoices"; "Send API Sales Invoice") { }
                actionref("Json Strings"; "Json String") { }
                actionref("Validate Json Strings"; "Validate Json String") { }
            }
        }

        addafter(Print)
        {
            action("For API Sales Invoice")
            {
                ApplicationArea = All;
                Caption = 'For API Sales Invoice';
                Ellipsis = true;
                Image = Statistics;

                trigger OnAction()
                var
                    salesInvoiceHeader: Record "Sales Invoice Header";
                    apiManament: Codeunit "EST API Management YVS";

                begin
                    if Rec."EST API Completed" then
                        Error('API Completed must be equal “No” in Sales Invoice No. : ' + Rec."No." + '.Current value is “Yes”.')
                    else begin
                        ;
                        if (Rec."EST For API SI") then begin
                            apiManament.UpdateSalesInvoiceHeadForAPI(Rec, false);
                            Commit();
                        end
                        else begin
                            apiManament.UpdateSalesInvoiceHeadForAPI(Rec, true);
                            Commit();
                        end;
                    end;

                end;

            }
            action("Clear Sent API")
            {
                ApplicationArea = All;
                Caption = 'Clear Sent API';
                Ellipsis = true;
                Image = Statistics;

                trigger OnAction()
                var
                    apiManament: Codeunit "EST API Management YVS";
                begin
                    apiManament.UpdateSalesInvoiceHeadAPIComplete(Rec, false);
                    Commit();
                end;

            }
            action("Send API Sales Invoice")
            {
                ApplicationArea = All;
                Caption = 'Send API Sales Invoice';
                Ellipsis = true;
                Image = Statistics;

                trigger OnAction()
                var
                    outPutText: Text;
                    siService: Codeunit "EST Sales invoice service";
                    JsonObject: JsonObject;
                begin
                    if Rec."EST API Completed" then
                        Error('API Completed must be equal “No” in Sales Invoice No. : ' + Rec."No." + '.Current value is “Yes”.')
                    else begin
                        ;
                        if not Rec."EST For API SI" then
                            Error('For API SI must be equal “Yes” in Sales Invoice No. : ' + Rec."No." + '.Current value is “No”.');

                        siService.process(Rec);
                        // outPutText := Format(JsonObject);
                        // Message(outPutText);
                    end;
                end;

            }

            action("Json String")
            {
                ApplicationArea = All;
                Caption = 'Json String';
                Ellipsis = true;
                Image = Statistics;

                trigger OnAction()
                var
                    outPutText: Text;
                    siService: Codeunit "EST Sales invoice service";
                    JsonObject: JsonObject;
                begin
                    JsonObject := siService.CreateJsonSalesInvoice(Rec);
                    outPutText := Format(JsonObject);
                    Message(outPutText);
                end;
            }

            action("Validate Json String")
            {
                ApplicationArea = All;
                Caption = 'Validate Json String';
                Ellipsis = true;
                Image = Statistics;

                trigger OnAction()
                var
                    outPutText: Text;
                    siService: Codeunit "EST Sales invoice service";
                    JsonObject: JsonObject;
                begin
                    JsonObject := siService.CreateJsonSalesInvoice(Rec);
                    siService.validate(JsonObject);
                    outPutText := Format(JsonObject);
                    Message(outPutText);
                end;
            }
        }
    }

    var
        myInt: Integer;
}