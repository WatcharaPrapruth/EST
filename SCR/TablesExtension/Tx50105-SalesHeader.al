tableextension 50105 "EST Sales Header" extends "Sales Header"
{
    fields
    {
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
            end;
            //KT ++
            trigger OnValidate()
            var
                TmpDimSetEntry: Record "Dimension Set Entry" temporary;
                DimVal: Record "Dimension Value";
                DimMgt: Codeunit DimensionManagement;
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                SalesSetup.Get();
                IF Rec."EST Route Name" <> xRec."EST Route Name" THEN BEGIN
                    DimMgt.GetDimensionSet(TmpDimSetEntry, "Dimension Set ID");
                    IF Rec."EST Route Name" = '' THEN BEGIN
                        IF TmpDimSetEntry.GET(TmpDimSetEntry."Dimension Set ID", SalesSetup."EST Route Name Dimension") THEN
                            TmpDimSetEntry.DELETE;
                    END ELSE BEGIN
                        IF DimVal.GET(SalesSetup."EST Route Name Dimension", Rec."EST Route Name") THEN BEGIN
                            IF NOT TmpDimSetEntry.GET(0, DimVal."Dimension Code") THEN BEGIN
                                TmpDimSetEntry.INIT;
                                TmpDimSetEntry."Dimension Set ID" := 0;
                                TmpDimSetEntry."Dimension Code" := DimVal."Dimension Code";
                                TmpDimSetEntry."Dimension Value Code" := Rec."EST Route Name";
                                TmpDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                                TmpDimSetEntry.INSERT;
                            END ELSE BEGIN
                                TmpDimSetEntry."Dimension Value Code" := Rec."EST Route Name";
                                TmpDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                                TmpDimSetEntry.MODIFY;
                            END;
                        END;
                    END;
                    "Dimension Set ID" := DimMgt.GetDimensionSetID(TmpDimSetEntry);
                END;
            end;
            //KT --
        }
        field(50106; "EST Route Name Description"; Text[50])
        {
            Caption = 'Route Name Description';
            Editable = false;
        }
        field(50107; "EST Dimension Route Code"; Code[20])
        {
            Caption = 'Dimension Route Code';
            TableRelation = Dimension;
        }
        //KT ++
        field(50108; "EST Is Deposit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Deposit';
        }
        field(50109; "EST PO Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'PO Date';
        }
        //KT --
        field(50110; "EST For API SI"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'For API SI';
            Editable = false;
        }
        modify("Posting No. Series")
        {
            trigger OnAfterValidate()
            begin
                initForAPI();
            end;
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            begin
                initForAPI();
            end;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                initForAPI();
            end;
        }
    }
    local procedure initForAPI()
    var
        apiMgt: Codeunit "EST API Management YVS";
        type: Enum "EST For API Type";
    begin
        type := "EST For API Type"::"For API SI";
        Rec."EST For API SI" := apiMgt.GetForAPI(Rec."Posting No. Series", type);
    end;
}