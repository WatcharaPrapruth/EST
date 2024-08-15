page 50101 "EST API Purchase Order Lines"
{
    APIGroup = 'ESTAPI';
    APIPublisher = 'YVS';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'estAPIPurchaseOrderLines';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'ESTPurchaseOrderLine';
    EntitySetName = 'Lines';
    PageType = API;
    SourceTable = "Purchase Line";
    SourceTableView = sorting("Document No.", "Line No.") order(ascending)
    where(Type = filter(Item), "Outstanding Amount" = filter(> 0));
    //where(Amount = filter(<> 0));
    //ODataKeyFields = "Line No.", "Document No.";
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

                field(ItemId; Rec."No.")
                {
                    Caption = 'No.';
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
                field(Company; Company)
                {
                    Caption = 'Company';
                }
                field(Line_No; Rec."Line No.")
                {
                    Caption = 'Line No.';
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

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Company := 'EST';
    end;

    var
        Company: Text;
}
