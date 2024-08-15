tableextension 50108 "EST Sales Inv Line" extends "Sales Invoice Line"
{
    fields
    {
        //KT ++
        field(50100; "EST Bin Pick"; Code[20])
        {
            Caption = 'EST Bin Pick';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //KT --
    }
}
