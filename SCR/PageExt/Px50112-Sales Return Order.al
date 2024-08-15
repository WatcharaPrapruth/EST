pageextension 50112 "EST Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting No. Series field.', Comment = '%';
            }
        }
    }
}