tableextension 50100 "EST No. Series" extends "No. Series"
{
    fields
    {
        field(50100; "EST For API PO"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'For API PO';
        }

        field(50101; "EST For API SI"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'For API SI';
        }
    }


    var
        myInt: Integer;
}