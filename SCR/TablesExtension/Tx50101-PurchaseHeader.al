tableextension 50101 "EST Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50100; "EST For API PO"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'For API PO';
            Editable = false;
        }
    }

    var
        myInt: Integer;
}