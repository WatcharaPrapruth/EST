tableextension 50103 "EST Sales Invoice Header(YVS)" extends "Sales Invoice Header"
{
    fields
    {
        field(50103; "EST API Completed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'API Completed';
            Editable = false;
        }

        field(50104; "EST For API SI"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'For API SI';
            Editable = false;
        }

        field(50105; "EST Route Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Route Name';
            Editable = false;
        }
        field(50106; "EST Route Name Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Route Name Description';
            Editable = false;
        }
        field(50107; "EST Dimension Route Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Route Code';
            TableRelation = Dimension;
            Editable = false;
        }
        //KT ++
        field(50108; "EST Is Deposit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Deposit';
            Editable = false;
        }
        field(50109; "EST PO Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'PO Date';
        }
        //KT --
    }


}