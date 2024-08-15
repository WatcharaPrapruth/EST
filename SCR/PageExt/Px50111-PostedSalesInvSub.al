pageextension 50111 "EST Posted Sales Inv Sub" extends "Posted Sales Invoice Subform"
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
