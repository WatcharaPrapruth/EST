page 50100 "EST API Purchase Orders"
{
    APIGroup = 'ESTAPI';
    APIPublisher = 'YVS';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'estAPIPurchaseOrders';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'ESTPurchaseOrder';
    EntitySetName = 'ESTPurchaseOrders';
    PageType = API;
    SourceTable = "Purchase Header";
    SourceTableView = where(Status = filter(Released), "EST For API PO" = filter(true), "Completely Received" = filter(false));
    //SourceTableView = where(Status = filter(Released), "EST For API PO" = filter(true));
    ODataKeyFields = "No.";
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(Vendor_Name; Rec."Buy-from Vendor Name")
                {
                    Caption = 'Buy-from Vendor Name';
                }
                field(Vendor_No; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Buy-from Vendor No.';
                }
            }
            group(Control)
            {
                part(PurchaseOrderLines; "EST API Purchase Order Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Lines', Locked = true;
                    SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    EntityName = 'ESTPurchaseOrderLine';
                    EntitySetName = 'Lines';

                }
            }
        }
    }

    var
        first: Boolean;
        interfaceLog: Record "EST Interface Log";


    trigger OnOpenPage()
    begin
        Rec.ReadIsolation := IsolationLevel::ReadCommitted;
        first := true;
    end;

    trigger OnAfterGetRecord()
    begin
        InsertLog(Rec);
    end;

    local procedure InsertLog(purchHeader: Record "Purchase Header")
    var
        no: Text;
        lastNum: Integer;
    begin
        no := Rec."No.";
        if (first) and (no <> '') then begin

            first := false;
            lastNum := 1;

            if interfaceLog.FindLast() then
                lastNum := interfaceLog."EST Entry No." + 1;

            Clear(interfaceLog);
            //interfaceLog."EST Entry No." := lastNum;
            interfaceLog."EST Action Page" := "EST Action Page"::"Purchase Order";
            interfaceLog."EST Direction" := "EST Direction"::Outbound;
            interfaceLog."EST Method Type" := "EST Method Type"::Select;
            interfaceLog."EST Primary Key Caption" := '[1: Purchase Header.]';
            interfaceLog."EST Primary Key Value 1" := no;
            interfaceLog."EST Status" := "EST Status Interface"::Success;
            //interfaceLog."EST Description" := 'Success';
            interfaceLog.Insert();
        end;
    end;

}
