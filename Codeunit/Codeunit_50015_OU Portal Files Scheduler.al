codeunit 50015 "OU Portal Files Scheduler"
{

    TableNo = "Job Queue Entry";

    trigger OnRun();
    var
        Selection: Integer;
    begin
        IF GUIALLOWED THEN BEGIN
            Selection := STRMENU('Module Fee,ReRegistration Fee,Exemption Fee,Resit Fee,Full Program Fee');
            CASE Selection OF
                0:
                    EXIT;
                1:
                    "Parameter String" := 'Module Fee';
                2:
                    "Parameter String" := 'ReRegistration Fee';
                3:
                    "Parameter String" := 'Exemption Fee';
                4:
                    "Parameter String" := 'Resit Fee';
                5:
                    "Parameter String" := 'Full Program Fee';
                6:
                    "Parameter String" := 'Module Upload';
            END;
        END;

        CASE Rec."Parameter String" OF
            'Module Fee':
                ModuleFee(ModuleFeeGVar);
            'ReRegistration Fee':
                ReRegistrationFee(ReRegistrationFeeGVar);
            'Exemption Fee':
                ExemptionResitFee(true, ExemptionResitFeeGVar);
            'Resit Fee':
                ExemptionResitFee(false, ExemptionResitFeeGVar);
            'Full Program Fee':
                FullPgmFee(FullPgmFeeGVar);
            'Module Upload':
                ModuleUpload(ModuleUploadGRec);
            ELSE
                ERROR('Parameter mismatch');
        END;

        IF GUIALLOWED THEN
            MESSAGE('Done');
    end;

    var
        ModuleFeeGVar: Record "Module Fee From OU Portal";
        ReRegistrationFeeGVar: Record "ReRegistration Fee OU Portal";
        ExemptionResitFeeGVar: Record "Exemption/Resit Fee OU Portal";
        FullPgmFeeGVar: Record "Full Prog. Fee From OU Protal";
        ModuleUploadGRec: Record "Module Upload";

    procedure ModuleFee(var ModuleFee: Record "Module Fee From OU Portal")
    var
        ModuleFee2: Record "Module Fee From OU Portal";
        ProcessModuleFee: Codeunit "Process Module Fee";
    begin
        ModuleFee.SetCurrentKey("Line No.");
        ModuleFee.SetRange("NAV Doc No.", '');
        if ModuleFee.FindSet() then
            repeat
                ModuleFee2 := ModuleFee;
                ModuleFee2.Error := '';
                if not ProcessModuleFee.Run(ModuleFee2) then begin
                    ModuleFee2.Error := copystr(GetLastErrorText(), 1, MaxStrLen(ModuleFee2.Error));
                    ModuleFee2.Modify();
                    Commit();
                end;

            until ModuleFee.Next() = 0;
    end;

    procedure ReRegistrationFee(var ReRegistrationFee: Record "ReRegistration Fee OU Portal")
    var
        ReRegistrationFee2: Record "ReRegistration Fee OU Portal";
        ReRegistrationFee3: Record "ReRegistration Fee OU Portal";
        ProcessReRegistrationFee: Codeunit "Process ReRegistration Fee";
    begin
        ReRegistrationFee.SetCurrentKey(PTN);
        ReRegistrationFee.SetRange("NAV Doc No.", '');
        ReRegistrationFee.SetFilter("Student ID", '<>%1', '');
        if ReRegistrationFee.FindSet() then
            repeat
                ReRegistrationFee2 := ReRegistrationFee;
                ReRegistrationFee2.Error := '';
                if not ProcessReRegistrationFee.Run(ReRegistrationFee2) then begin
                    ReRegistrationFee2.Error := copystr(GetLastErrorText(), 1, MaxStrLen(ReRegistrationFee2.Error));
                    ReRegistrationFee2.Modify();
                    Commit();
                end;
            until ReRegistrationFee.Next() = 0;
    end;

    procedure ExemptionResitFee(IsExemption: Boolean; var ExemptionResitFee: Record "Exemption/Resit Fee OU Portal")
    var
        ExemptionResitFee2: Record "Exemption/Resit Fee OU Portal";
        ProcessExemptionResitFee: Codeunit "Process ExemptionResit Fee";
    begin
        ExemptionResitFee.SetCurrentKey("Line No.");
        if IsExemption then
            ExemptionResitFee.SetRange(Exemption, true)
        else
            ExemptionResitFee.SetRange(Resit, true);
        ExemptionResitFee.SetRange("NAV Doc No.", '');
        if ExemptionResitFee.FindSet() then
            repeat
                ExemptionResitFee2 := ExemptionResitFee;
                ExemptionResitFee2.Error := '';
                if not ProcessExemptionResitFee.Run(ExemptionResitFee2) then begin
                    ExemptionResitFee2.Error := copystr(GetLastErrorText(), 1, MaxStrLen(ExemptionResitFee2.Error));
                    ExemptionResitFee2.Modify();
                    Commit();
                end;
            until ExemptionResitFee.Next() = 0;
    end;

    procedure FullPgmFee(var FullPgmFee: Record "Full Prog. Fee From OU Protal")
    var
        FullPgmFee2: Record "Full Prog. Fee From OU Protal";
        ProcessFullPgmFee: Codeunit "Process Full Program Fee";
    begin
        FullPgmFee.SetCurrentKey("Line No.");
        FullPgmFee.SetRange("NAV Doc No.", '');
        if FullPgmFee.FindSet() then
            repeat
                FullPgmFee2 := FullPgmFee;
                FullPgmFee2.Error := '';
                if not ProcessFullPgmFee.Run(FullPgmFee2) then begin
                    FullPgmFee2.Error := copystr(GetLastErrorText(), 1, MaxStrLen(FullPgmFee2.Error));
                    FullPgmFee2.Modify();
                    Commit();
                end;
            until FullPgmFee.Next() = 0;
    end;

    procedure ModuleUpload(var UploadModule: Record "Module Upload")
    var
        ModuleUpload: Record "Module Upload";
        ProcessModuleUpload: Codeunit "Upload Module Process";
        LinesCreated: Integer;
    begin
        Clear(LinesCreated);
        UploadModule.SetCurrentKey("Entry No.");
        UploadModule.SetRange("NAV Doc No.", '');
        if UploadModule.FindSet() then
            repeat
                ModuleUpload := UploadModule;
                ModuleUpload.Error := '';
                if not ProcessModuleUpload.Run(ModuleUpload) then begin
                    ModuleUpload.Error := copystr(GetLastErrorText(), 1, MaxStrLen(ModuleUpload.Error));
                    ModuleUpload.Modify();
                    Commit();
                end else
                    LinesCreated += 1;
            until UploadModule.Next() = 0;
        if GuiAllowed then
            Message('%1 Modules has been created.', LinesCreated);
    end;
}

