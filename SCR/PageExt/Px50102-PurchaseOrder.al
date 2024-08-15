pageextension 50102 "EST Purchase Header" extends "Purchase Order"
{
    layout
    {
        addafter("Receiving No.")
        {
            field("EST For API PO"; Rec."EST For API PO")
            {
                ApplicationArea = All;
                ToolTip = 'For API PO';
            }
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }

    actions
    {
        addafter("Category_Category6")
        {
            actionref(ForAPIPurchaseOrders; ForAPIPurchaseOrder) { }
        }

        addafter(Approve)
        {
            action(ForAPIPurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'For API Purchase Order';
                Ellipsis = true;
                Image = Statistics;

                trigger OnAction()
                begin
                    if Rec."EST For API PO" then
                        Rec."EST For API PO" := false
                    else
                        Rec."EST For API PO" := true;
                end;
            }
        }
    }

    var
        myInt: Integer;
}