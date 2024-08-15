pageextension 50103 "EST Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Salesperson Dimension Code")
        {
            field("EST Route Name Dimension"; Rec."EST Route Name Dimension")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Route Name Dimension field.', Comment = '%';
            }
        }
        addafter(SalesReceiptInformation)
        {
            group(InterfacePDASetup)
            {
                Caption = 'Interface PDA Setup';
                field("EST Sales Interface Path"; rec."EST Sales Interface Path")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sales Interface Path. field.';
                }
                field("EST SI Method"; Rec."EST SI Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Method field.', Comment = '%';
                }
                field("EST SI Username"; Rec."EST SI Username")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Username field.', Comment = '%';
                }
                field("EST SI Password"; Rec."EST SI Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Password field.', Comment = '%';
                    ExtendedDatatype = Masked;
                }
            }
        }
    }
}