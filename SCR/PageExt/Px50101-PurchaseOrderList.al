pageextension 50101 "EST Purchase Order List(YVS)" extends "Purchase Order List"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("EST For API PO"; Rec."EST For API PO")
            {
                ApplicationArea = All;
                ToolTip = 'For API PO';
            }
        }
    }

    /*
        actions
        {
            addafter("Category_Category7")
            {
                actionref(ForAPIPurchaseOrders; ForAPIPurchaseOrder) { }
            }

            addafter(Send)
            {

                action(ForAPIPurchaseOrder)
                {
                    ApplicationArea = All;
                    Caption = 'For API Purchase Order';
                    Ellipsis = true;
                    Image = Statistics;

                    trigger OnAction()
                    begin
                        if Rec."For API PO" then
                            Rec."For API PO" := false
                        else
                            Rec."For API PO" := true;
                    end;

                }

            }
        }
      */
}