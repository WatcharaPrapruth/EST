pageextension 50110 ESTSalesOrderProSub extends "EST Sales Order Sub Pro"
{
    layout
    {
        //KT ++
        addafter("Bin Code")
        {
            field("EST Suggest Pick"; Rec."EST Bin Pick")
            {
                ApplicationArea = All;
            }
        }
        //KT --
    }
}
