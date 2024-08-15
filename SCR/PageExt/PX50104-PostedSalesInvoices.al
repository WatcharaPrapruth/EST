pageextension 50104 "EST Posted Sales Invoices(YVS)" extends "Posted Sales Invoices"
{
    layout
    {
        addafter(Closed)
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
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}