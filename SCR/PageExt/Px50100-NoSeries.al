pageextension 50100 "EST No. Series" extends "No. Series"
{
    layout
    {
        addafter("Manual Nos.")
        {
            field("EST For API PO"; Rec."EST For API PO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For API SO field.', Comment = '%';
            }

            field("EST For API SI"; Rec."EST For API SI")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For API SI field.', Comment = '%';
            }
        }
    }

    var
        myInt: Integer;
}