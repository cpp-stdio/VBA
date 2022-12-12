Attribute VB_Name = "Involved_Sheet"
Option Explicit
'##############################################################################################################################
'
'   �V�[�g�֘A
'
'   �V�K�쐬�� : 2017/08/30
'   �ŏI�X�V�� : 2022/11/28
'
'   �V�K�쐬�G�N�Z���o�[�W���� : Office Professional Plus 2010 , 14.0.7145.5000(32�r�b�g)
'   �ŏI�X�V�G�N�Z���o�[�W���� : Office Professional Plus 2016 , 16.0.5.56.1000(32�r�b�g)
'
'##############################################################################################################################

'==============================================================================================================================
'   ���̖��O���V�[�g���ɓK�؂Ȗ��O�ł��邩��������
'
'   �߂�l : OK(True), NG(False)
'
'   sheetName : �V�[�g��
'==============================================================================================================================
Public Function checkSheetName(ByVal sheetName As String) As Boolean
    checkSheetName = False
    '��������1 : ��̖��O�ł͂Ȃ��B
    If StrComp(sheetName, "", vbBinaryCompare) = 0 Then Exit Function
    '��������2 : �܂�ł͂����Ȃ������񂪂Ȃ��B
    Dim textFor As Variant
    For Each textFor In Array(":", "\", "/", "?", "*", "[", "]")
        If InStr(sheetName, CStr(textFor)) > 0 Then Exit Function
    Next textFor
    '��������3 : ���O��31�����ȓ��ł���B
    If Len(sheetName) > 31 Then Exit Function
    '��������4 : �����̃V�[�g�͑��ݏo���Ȃ��B
    'aNewSheet�ɂĕs������������̂ŕ�������B
    checkSheetName = True
End Function

'==============================================================================================================================
'   ���������O�̃V�[�g��T��
'
'   �߂�l : ���������O�����V�[�g�B�Ȃ��ꍇ�́ANothing���ԋp�����
'
'   sheetName : �V�[�g��
'   book : �Ώۂ̃u�b�N�i�C�Ӂj
'==============================================================================================================================
Public Function sheetToEqualsName(ByVal sheetName As String, Optional ByRef book As Workbook = Nothing) As Worksheet

    Dim searchBook As Workbook
    Set searchBook = isBook(book)

    Dim sheet As Worksheet
    For Each sheet In searchBook.sheets
        If StrComp(sheet.Name, sheetName, vbBinaryCompare) = 0 Then
            Set sheetToEqualsName = sheet
            Exit Function
        End If
    Next
    Set sheetToEqualsName = Nothing
End Function

'==============================================================================================================================
'   �V���ȃV�[�g���쐬
'
'   �߂�l :�V�K�쐬���ꂽWorksheet���ԋp����A�쐬�ς̏ꍇ�͂���Worksheet���ԋp�����B
'           �쐬�o���Ȃ������ꍇ��Nothing���ԋp�����
'
'   sheetName : �V�[�g��
'   book : �Ώۂ̃u�b�N�i�C�ӁA�����͂̏ꍇThisWorkbook�j
'==============================================================================================================================
Public Function aNewSheet(ByVal sheetName As String, Optional ByRef book As Workbook = Nothing) As Worksheet
    Set aNewSheet = Nothing
    '�K�؂Ȗ��O�łȂ��ꍇ
    If Not checkSheetName(sheetName) Then Exit Function
    '�Ώۂ̃u�b�N�����͂���Ă��Ȃ��ꍇ
    Dim addBook As Workbook
    Set addBook = isBook(book)
    '�쐬�ς݂�������
    Dim sheet As Worksheet
    Set sheet = sheetToEqualsName(sheetName, addBook)
    If Not sheet Is Nothing Then
        Set aNewSheet = sheet
        Exit Function
    End If
    '�V���ȃV�[�g���쐬
    Set sheet = addBook.sheets.add()
    sheet.Name = sheetName
    sheet.Activate '�A�N�e�B�u�����Ă��������������ڂ͗ǂ��B
    Set aNewSheet = sheet
End Function

'==============================================================================================================================
'   �V�[�g���폜����
'
'   �߂�l : ����(True), ���s(False)
'
'   sheet : �폜����V�[�g�B���������ꍇ�A�A�N�Z�X�s�ɂȂ�̂Œ��ӂ��K�v
'   book  : �Ώۂ̃u�b�N�i�C�Ӂj
'==============================================================================================================================
Public Function aDeletedSheet(ByVal sheetName As String, Optional ByRef book As Workbook = Nothing) As Boolean
    Dim sheet As Worksheet
    Set sheet = sheetToEqualsName(sheetName, book)
    aDeletedSheet = aDeletedSheetEx(sheet, book)
    Set sheet = Nothing
End Function

Public Function aDeletedSheetEx(ByRef sheet As Worksheet, Optional ByRef book As Workbook = Nothing) As Boolean
    aDeletedSheetEx = False
    
    If sheet Is Nothing Then
        'Nothing�Ȃ̂ŁA���ɍ폜�ς݂Ɖ��肷��B
        aDeletedSheetEx = True
        Exit Function
    End If
    
    '�폜����^�C�~���O�Ń��b�Z�[�W���\������邪�@�\�I�ɕs�K�v�Ȃ̂Ŕ�\���ɂ��Ă���
    Application.DisplayAlerts = False
    Dim deleteBook As Workbook
    Set deleteBook = isBook(book)
    
    Dim deleteSheet As Worksheet
    For Each deleteSheet In deleteBook.sheets
        If StrComp(sheet.Name, deleteSheet.Name, vbBinaryCompare) = 0 Then
            Call deleteBook.sheets(sheet.Name).Delete
            Set sheet = Nothing  '�V�[�g���폜����
            aDeletedSheetEx = True '�߂�l��ύX
            Exit For
        End If
    Next
    
    '���b�Z�[�W��\����Ԃɖ߂�
    Application.DisplayAlerts = True
End Function
'==============================================================================================================================
'   �V�[�g�̏���S�č폜����
'
'   sheet : �ΏۃV�[�g
'==============================================================================================================================
Public Function aInfoErasureSheet(ByRef sheet As Worksheet)
    Dim i As Long: i = 0
    '�Z����S�č폜
    sheet.cells.Clear
    sheet.Columns.Clear
    sheet.Rows.Clear
    '�e�[�u���̏����폜
    For i = sheet.ListObjects.count To 1 Step -1
        Call sheet.ListObjects.Item(i).Delete
    Next i
    '���ߍ��݃O���t���폜
    For i = sheet.ChartObjects.count To 1 Step -1
        Call sheet.ChartObjects(i).Delete
    Next i
    '������̃y�[�W��؂���폜
    'sheet.DisplayPageBreaks = False
    '�s�{�b�g�e�[�u�����폜
    For i = sheet.PivotTables.count To 1 Step -1
        Call sheet.PivotTables(i).ClearTable
    Next i
    '�}�A�N���b�v�A�[�g�A�}�`�ASmartArt�̍폜
    For i = sheet.Shapes.count To 1 Step -1
        Call sheet.Shapes.Item(i).Delete
    Next i
    '�w�b�^�[�A�t�b�^�[�͊��S�ɍ폜���邱�Ƃ͕s�\�炵��
    With sheet.PageSetup
        For i = .Pages.count To 1 Step -1
            .Pages.Item(i).CenterFooter = ""
            .Pages.Item(i).CenterHeader = ""
            .Pages.Item(i).LeftFooter = ""
            .Pages.Item(i).LeftHeader = ""
            .Pages.Item(i).RightFooter = ""
            .Pages.Item(i).RightHeader = ""
        Next i
        .LeftHeader = ""
        .CenterHeader = ""
        .RightHeader = ""
        .LeftFooter = ""
        .CenterFooter = ""
        .RightFooter = ""
        .DifferentFirstPageHeaderFooter = True
    End With
    
End Function
'==============================================================================================================================
'   �V�[�g���œ��͂���Ă��鐔����l�ɕϊ�����
'   ��1�@���p����ꍇ�́uInvolved_Other.bas�v�̃C���|�[�g�����肢���܂�
'   ��2�@���������̎����Čv�Z���s���̂œ��삪�d���Ȃ�\��������܂�
'   ��3�@�uInvolved_Call�v�ɒP��Z���̐�����l�ɕϊ�����v���O����������܂��B
'
'   �߂�l : �ϊ�����(True), NG(False)
'
'   sheetName : �V�[�g��
'==============================================================================================================================
Public Function aSheetDeleteFormula(ByVal sheetName As String, Optional ByRef book As Workbook = Nothing) As Boolean
    Dim sheet As Worksheet
    Set sheet = sheetToEqualsName(sheetName, book)
    aSheetDeleteFormula = aSheetDeleteFormulaDx(sheet)
    Set sheet = Nothing
End Function

Public Function aSheetDeleteFormulaDx(ByRef sheet As Worksheet) As Boolean
    aSheetDeleteFormulaDx = False
    If sheet Is Nothing Then Exit Function
    
    Dim base As range
    Dim cell As range
    Dim row As Long
    Dim rowMax As Long
    Dim column As Long
    Dim columnMax As Long
    Dim text As String
    Dim value As Variant
    
    Set base = sheet.UsedRange.range("A1")
    rowMax = sheet.UsedRange.Rows.count - 1
    columnMax = sheet.UsedRange.Columns.count - 1
    
    For row = rowMax To 0 Step -1
        For column = columnMax To 0 Step -1
            Set cell = base.Offset(row, column)
            
            If WorksheetFunction.IsFormula(cell) Then
                cell.Calculate '�Čv�Z
                text = cell.value
                '���l�̏ꍇ�͂��̂܂�"���l"�Ƃ��ĕ\��������i���t�A���z���͑ΏۊO�j
                If checkNumericalValue(text, value) Then
                    cell.value = value
                Else
                    cell.NumberFormatLocal = "@"
                    cell.value = text
                End If
            End If
        Next
    Next
    
    Set base = Nothing
    Set cell = Nothing
    aSheetDeleteFormulaDx = True
End Function

'==============================================================================================================================
'   �u�b�N�̗L��
'==============================================================================================================================
Private Function isBook(ByRef book As Workbook) As Workbook
    If book Is Nothing Then
        Set isBook = ThisWorkbook
    Else
        Set isBook = book
    End If
End Function

