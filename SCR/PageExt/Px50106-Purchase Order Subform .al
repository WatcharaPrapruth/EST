pageextension 50106 "EST Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Quantity Invoiced")
        {
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units on the order line have not yet been received.';
            }
        }
        // addafter("Location Code")
        // {
        //     field("Bin Code Field"; Rec."Bin Code")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies how many units on the order line have not yet been received.';
        //     }
        // }
    }

}