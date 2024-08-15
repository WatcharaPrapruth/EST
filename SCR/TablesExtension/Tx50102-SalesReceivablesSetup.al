tableextension 50102 "EST Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "EST Sales Interface Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Interface Path';
            Editable = true;
        }
        field(50101; "EST Route Name Dimension"; Code[20])
        {
            Caption = 'Route Name Dimension';
            TableRelation = Dimension;
        }
        field(50102; "EST SI Username"; Text[50])
        {
            Caption = 'Username';
            DataClassification = ToBeClassified;
        }
        field(50103; "EST SI Password"; Text[150])
        {
            Caption = 'Password';
            DataClassification = ToBeClassified;
        }
        field(50104; "EST SI Method"; Text[15])
        {
            Caption = 'Method';
            DataClassification = ToBeClassified;
        }
    }
}