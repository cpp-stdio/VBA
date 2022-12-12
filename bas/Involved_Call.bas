Attribute VB_Name = "Involved_Call"
Option Explicit
'##############################################################################################################################
'
'   �V�[�g�֘A
'
'   �V�K�쐬�� : 2022/11/10
'   �ŏI�X�V�� : 2022/11/21
'
'   �V�K�쐬�G�N�Z���o�[�W���� : Office Professional Plus 2016 , 16.0.5.56.1000(32�r�b�g)
'   �ŏI�X�V�G�N�Z���o�[�W���� : Office Professional Plus 2016 , 16.0.5.56.1000(32�r�b�g)
'
'##############################################################################################################################
'==============================================================================================================================
'   aDeleteStrikethrough�Ŏg�p�����\����
'   �Q�lURL�Fhttps://vbabeginner.net/remove-strikethroughs-preserving-fonts/
'==============================================================================================================================
Private Type ST_FONT
    Background      As Long
    Bold            As Boolean
    Color           As Double
    ColorIndex      As Long
    FontStyle       As String
    Italic          As Boolean
    Name            As String
    OutlineFont     As Boolean
    Shadow          As Boolean
    Size            As Double
    Strikethrough   As Boolean
    Subscript       As Boolean
    Superscript     As Boolean
    ThemeColor      As Variant
    ThemeFont       As XlThemeFont
    TintAndShade    As Double
    Underline       As Long
End Type
'==============================================================================================================================
'   ���̃V�[�g�œ��͂���Ă��鐔����l�ɕϊ�����
'   ���p����ꍇ�́uInvolved_Sheet.bas�v�̃C���|�[�g�����肢���܂�
'   �����������̎����Čv�Z���s���̂œ��삪�d���Ȃ�\��������܂�
'
'   �߂�l : �ϊ�����(True), NG(False)
'
'   sheetName : �V�[�g��
'==============================================================================================================================
Public Function aCallDeleteFormula(ByRef range As range) As Boolean
    aCallDeleteFormula = False
    'If sheet = Nothing Then Exit Function
    
    'Dim cell As range
    'Dim row As Long
    'Dim rowMax As Long
    'Dim column As Long
    'Dim columnMax As Long
    'Dim value As String
    
    'Set base = sheet.UsedRange.range("A1")
    'rowMax = sheet.UsedRange.Rows.count - 1
    'columnMax = sheet.UsedRange.Columns.count - 1
    
    'For row = rowMax To 0 Step -1
    '    For column = columnMax To 0 Step -1
    '        Set cell = base.Offset(row, column)
    '
    '        If WorksheetFunction.IsFormula(cell) Then
    '            'cell.Calculate '�Čv�Z
    '            value = cell.value
    '            cell.NumberFormatLocal = "@"
    '            cell.value = value
    '        End If
    '    Next
    'Next
    
    'Set base = Nothing
    'Set cell = Nothing
    aCallDeleteFormula = True
End Function
'==============================================================================================================================
'   ���������̂��������̂ݍ폜����
'   �Q�lURL�Fhttps://vbabeginner.net/remove-strikethroughs-preserving-fonts/
'
'   �g�����F
'               Dim r   As range    '// �Z��
'               For Each r In Selection
'                   Call aCallDeleteStrikethrough(r)
'               Next
'
'   �߂�l : �폜���ꂽ�Z��, �G���[�̏ꍇ��Nothing
'
'   r : �ΏۃZ��
'==============================================================================================================================
Public Function aDeleteStrikethrough(ByRef r As range) As range

On Error GoTo ErrorHandler '���L�œ�G���[���������邱�Ƃ�����
 
    Dim i       As Long         '// �����񒷃��[�v�J�E���^
    Dim iLen    As Long         '// �Z��������
    Dim C       As characters   '// �������Characters�I�u�W�F�N�g
    Dim f       As Font         '// 1�������Ƃ�Font�I�u�W�F�N�g
    Dim fAr()   As ST_FONT      '// Font�I�u�W�F�N�g�ݒ�l�ێ��p�̍\���̔z��
    Dim s       As String       '// �������������ς݂̕�����
    Dim iFont   As Long         '// Font�I�u�W�F�N�g�ݒ�p�z��̃C���f�b�N�X
    
    '// �Z�����ݒ莞�͏����I��
    If (r.value = "") Then Exit Function
    
    iFont = 0
    iLen = Len(r.value)
    ReDim fAr(iLen)
    
    '// �Z����������P���������[�v
    For i = 1 To iLen
        '// 1��������Characters�I�u�W�F�N�g���擾
        Set C = r.characters(i, 1)
        '// Font�I�u�W�F�N�g���擾
        Set f = C.Font
        
        '// �Ώۂ̂P�����Ɏ����������ݒ肳��Ă��Ȃ��ꍇ
        If f.Strikethrough = False Then
            '// �����������ݒ�̕�������擾
            s = s & C.text
            
            '// Font�I�u�W�F�N�g�̊e�v���p�e�B��ێ�
            fAr(iFont).Name = f.Name
            fAr(iFont).FontStyle = f.FontStyle
            fAr(iFont).Size = f.Size
            fAr(iFont).Strikethrough = f.Strikethrough
            fAr(iFont).Superscript = f.Superscript
            fAr(iFont).Subscript = f.Subscript
            fAr(iFont).OutlineFont = f.OutlineFont
            fAr(iFont).Shadow = f.Shadow
            fAr(iFont).Underline = f.Underline
            'fAr(iFont).ThemeColor = f.ThemeColor
            fAr(iFont).Color = f.Color
            fAr(iFont).TintAndShade = f.TintAndShade
            fAr(iFont).ThemeFont = f.ThemeFont
 
            iFont = iFont + 1
        End If
    Next
    
    '// ������������������������Z���ɐݒ�
    r.FormulaR1C1 = s
    
    '// �ēx�Z���̕����񒷂��擾
    iLen = Len(s)
    
    '// ������������������������P���������[�v
    For i = 1 To iLen
        '// 1��������Font�I�u�W�F�N�g���Đݒ�̂��ߎ擾
        Set f = r.characters(Start:=i, length:=1).Font
        
        '// �C���f�b�N�X�擾
        iFont = i - 1
        
        '// Font�I�u�W�F�N�g�̊e�v���p�e�B��ێ����Ă������l�ōĐݒ�
        f.Name = fAr(iFont).Name
        f.FontStyle = fAr(iFont).FontStyle
        f.Size = fAr(iFont).Size
        f.Strikethrough = fAr(iFont).Strikethrough
        f.Superscript = fAr(iFont).Superscript
        f.Subscript = fAr(iFont).Subscript
        f.OutlineFont = fAr(iFont).OutlineFont
        f.Shadow = fAr(iFont).Shadow
        f.Underline = fAr(iFont).Underline
        'f.ThemeColor = fAr(iFont).ThemeColor
        f.Color = fAr(iFont).Color
        f.TintAndShade = fAr(iFont).TintAndShade
        f.ThemeFont = fAr(iFont).ThemeFont
    Next
    
    Set aDeleteStrikethrough = r
    Exit Function
ErrorHandler:
    Set aDeleteStrikethrough = Nothing
End Function
