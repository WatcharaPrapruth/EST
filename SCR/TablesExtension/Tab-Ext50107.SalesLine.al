tableextension 50107 SalesLine extends "Sales Line"
{
    fields
    {
        //KT ++
        field(50100; "EST Bin Pick"; Code[20])
        {
            Caption = 'EST Bin Pick';
            DataClassification = CustomerContent;
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));
        }
        //KT --
    }
}
