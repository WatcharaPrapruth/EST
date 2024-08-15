tableextension 50104 "EST Customer(YVS)" extends Customer
{
    fields
    {
        // field(50104; "EST Route Name Dimension"; Code[20])
        // {
        //     Caption = 'Route Name Dimension';
        //     TableRelation = Dimension;
        // }
        field(50105; "EST Route Name"; Code[20])
        {
            Caption = 'Route Name';

            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
            //                                               Blocked = const(false));
            TableRelation = "Dimension Value";
            trigger OnLookup()
            var
                dimenstionValue: Record "Dimension Value";
                setUp: Record "Sales & Receivables Setup";
            begin
                if setUp.FindFirst then begin
                    dimenstionValue.SETRANGE("Dimension Code", setUp."EST Route Name Dimension");
                    if dimenstionValue.FINDFIRST then begin
                        if PAGE.RunModal(0, dimenstionValue) = ACTION::LookupOK then begin
                            Rec."EST Route Name" := dimenstionValue.Code;
                            Rec."EST Route Name Description" := dimenstionValue.Name;
                            Rec."EST Dimension Route Code" := setUp."EST Route Name Dimension";
                        end;
                    end
                    else begin
                        Rec."EST Route Name" := '';
                        Rec."EST Route Name Description" := '';
                        Rec."EST Dimension Route Code" := '';
                    end;
                end;

                setDefaultDimension();
            end;

            trigger OnValidate()
            begin
                setDefaultDimension();
            end;
        }
        field(50106; "EST Route Name Description"; Text[50])
        {
            Caption = 'Route Name Description';
        }
        field(50107; "EST Dimension Route Code"; Code[20])
        {
            Caption = 'Dimension Route Code';
            TableRelation = Dimension;
        }
    }

    procedure setDefaultDimension(): Boolean
    var
        defaultDimension: Record "Default Dimension";
        setUp: Record "Sales & Receivables Setup";
    begin
        if (Rec."EST Route Name" = xRec."EST Route Name") then
            exit(true);

        Clear(defaultDimension);
        if xRec."EST Route Name" = '' then begin
            defaultDimension.SetRange("Table ID", xRec.RecordId.TableNo);
            defaultDimension.SetRange("No.", xRec."No.");
            if setUp.FindFirst then begin
                defaultDimension.SetRange("Dimension Code", setUp."EST Route Name Dimension")
            end;
            //defaultDimension.SetRange("Value Posting", "Default Dimension Value Posting Type"::"Code Mandatory");
            if defaultDimension.FINDFIRST then begin
                defaultDimension.Delete();
            end;
            insertDefaultDimension();
        end
        else begin
            defaultDimension.SetRange("Table ID", xRec.RecordId.TableNo);
            defaultDimension.SetRange("No.", xRec."No.");
            defaultDimension.SetRange("Dimension Code", xRec."EST Dimension Route Code");
            defaultDimension.SetRange("Dimension Value Code", xRec."EST Route Name");
            defaultDimension.SetRange("Value Posting", "Default Dimension Value Posting Type"::"Code Mandatory");
            if defaultDimension.FINDFIRST then begin
                defaultDimension.Delete();
            end;
            insertDefaultDimension();
        end;
    end;

    procedure insertDefaultDimension()
    var
        defaultDimension: Record "Default Dimension";
    begin
        defaultDimension.Init();
        defaultDimension."Table ID" := Rec.RecordId.TableNo;
        defaultDimension."No." := Rec."No.";
        defaultDimension."Dimension Code" := Rec."EST Dimension Route Code";
        defaultDimension."Dimension Value Code" := rec."EST Route Name";
        defaultDimension."Value Posting" := "Default Dimension Value Posting Type"::"Code Mandatory";
        defaultDimension.Insert();
    end;
}