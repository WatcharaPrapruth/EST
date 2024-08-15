pageextension 50107 "EST Customer Card(YVS)" extends "Customer Card"
{
    layout
    {
        addbefore("Shipment Method Code")
        {
            field("EST Route Name"; Rec."EST Route Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Route Name field.', Comment = '%';
            }
        }
    }
}