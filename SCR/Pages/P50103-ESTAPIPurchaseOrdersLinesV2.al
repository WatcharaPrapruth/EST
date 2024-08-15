page 50103 "EST API Purchase Order LinesV2"
{
    APIGroup = 'ESTAPI';
    APIPublisher = 'YVS';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'estAPIPurchaseOrderLines';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'ESTPurchaseOrderLineV2';
    EntitySetName = 'ESTPurchaseOrderLinesV2';
    PageType = API;
    SourceTable = "Purchase Line";
    SourceTableTemporary = false;
    //ODataKeyFields = "Document Type", "No.";
    ODataKeyFields = SystemId;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(ItemId; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(Line_No; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(Purchase_Unit; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(Base_Qty; Rec."Quantity (Base)")
                {
                    Caption = 'Quantity (Base)';
                }
                field(Remaining_Qty; Rec."Outstanding Quantity")
                {
                    Caption = 'Outstanding Quantity';
                }
                field(Unit_Price; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field(Net_Amount; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field(ItemDescription; Rec.Description)
                {
                    Caption = 'Description';
                }

                field(ItemDescription2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }

            }
        }
    }
}
