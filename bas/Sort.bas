Attribute VB_Name = "Sort"
Option Explicit
'------------------------------------------------------------------------------------------------------------------------------
'   �������Ȃ��ꍇ�Ɏg���\�[�g
'   SortData : �\�[�g�������ꎟ���z��
'------------------------------------------------------------------------------------------------------------------------------
Function BubbleSort(SortData As Variant, Min As Long, Max As Long)
    Dim Tmp As Variant '�z��ړ��p
    Dim X As Long, Y As Long
    For X = Min To Max
        For Y = Min To Max
            If SortData(X) < SortData(Y) Then
                Tmp = SortData(X)
                SortData(X) = SortData(Y)
                SortData(Y) = Tmp
            End If
        Next Y
    Next X
End Function
'------------------------------------------------------------------------------------------------------------------------------
'   ���������ꍇ�Ɏg���\�[�g
'   SortData : �\�[�g�������ꎟ���z��
'------------------------------------------------------------------------------------------------------------------------------
Function QuickSort(SortData As Variant, Min As Long, Max As Long)
    Dim Left As Long: Left = Min    '�����[�v�J�E���^
    Dim Right As Long: Right = Max  '�E���[�v�J�E���^
    Dim Median As Variant           '�����l
    Dim Tmp As Variant              '�z��ړ��p
    '�\�[�g�I���ʒu�ȗ����͔z��v�f����ݒ�
    If (Right <= -1) Then
        Right = UBound(SortData)
    End If
    Median = SortData((Min + Max) / 2)
    Do
        '�z��̍������璆���l���傫���l��T��
        Do
            If (SortData(Left) >= Median) Then
                Exit Do
            End If
            Left = Left + 1
        Loop
        '�z��̉E�����璆���l���傫���l��T��
        Do
            If (Median >= SortData(Right)) Then
                Exit Do
            End If
            Right = Right - 1
        Loop
        '�����̕����傫����΂����ŏ����I������
        If Left >= Right Then
            Exit Do
        End If
        '�E���̕����傫���ꍇ�́A���E�����ւ���
        Tmp = SortData(Left)
        SortData(Left) = SortData(Right)
        SortData(Right) = Tmp
        '// �������P�E�ɂ��炷
        Left = Left + 1
        '// �E�����P���ɂ��炷
        Right = Right - 1
    Loop
    '�����l�̍������ċA�ŋ��낵���N�C�b�N�\�[�g�̊J�n
    If (Min < Left - 1) Then
        Call QuickSort(SortData, Min, Left - 1)
    End If
    '�����l�̉E�����ċA�ŋ��낵���N�C�b�N�\�[�g�̊J�n
    If (Right + 1 < Max) Then
        Call QuickSort(SortData, Right + 1, Max)
    End If
End Function
