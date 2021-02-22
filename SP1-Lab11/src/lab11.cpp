// Lab11.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Lab11.h"
#include "vectsse.h"
#include "vectfpu.h"
#include "module.h"
#include <stdio.h>
#include <string>

#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;								// поточний екземпляр TCHAR szTitle[MAX_LOADSTRING];					// текст рядка заголовка              TCHAR szWindowClass[MAX_LOADSTRING];			// ім’я класу головного вікна

// Форвардні оголошення функцій, включених в цей модуль коду:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	About(HWND, UINT, WPARAM, LPARAM);

int APIENTRY _tWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPTSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

 	// TODO: Place code here.
	MSG msg;
	HACCEL hAccelTable;

	// Ініціалізація глобальних рядків
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_LAB11, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// Ініціалізація додатку
	if (!InitInstance (hInstance, nCmdShow))
	{
		return FALSE;
	}

	hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_LAB11));

	// Цикл основного повідомлення:
	while (GetMessage(&msg, NULL, 0, 0))
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	return (int) msg.wParam;
}




//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: реєструє клас вікна.
//
//  КОМЕНТАР:
//
//  Ця функція і її використання необхідні тільки в разі, якщо потрібно, щоб даний код
//  був сумісний з системами Win32, що не мають функції RegisterClassEx
//  яка була додана в Windows 95. Виклик цієї функції важливий для того,
//  щоб додаток отримав "якісні" дрібні значки і встановив зв'язок з ними.
//
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_LAB11));
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName	= MAKEINTRESOURCE(IDC_LAB11);
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

	return RegisterClassEx(&wcex);
}

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: зберігає обробку примірника і створює головне вікно.
//
//   КОМЕНТАРІ:
//
//   У даній функції дескриптор екземпляра зберігається в глобальній змінній, а також
//   створюється і виводиться на екран головне вікно програми.
//
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   HWND hWnd;

   hInst = hInstance; // Зберегти дескриптор екземпляру в глобальній змінній

   hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

   if (!hWnd)
   {
      return FALSE;
   }

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}

__declspec(align(16)) float oA[1000];
__declspec(align(16)) float oB[1000];
__declspec(align(16)) float res;
__declspec(align(16)) char TextBuf[100];

void prepare() {
	for (long i = 0; i < 1000; i++)
	{
		oA[i] = 1.0 + i;
		oB[i] = pow(-1.0, i);
	}
}


void myVectSSE(HWND hWnd)

{
	prepare();
	
	SYSTEMTIME st;
	long tst, ten;
	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute + 1000 * (long)st.wSecond + (long)st.wMilliseconds;

	for (long i = 0; i<1000000; i++) //повторюємо мільйон разів 
	{
		MyDotProduct_SSE(&res, oB, oA, 1000);
	}

	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute + 1000 * (long)st.wSecond + (long)st.wMilliseconds - tst;

	sprintf_s(TextBuf, "Скалярний добуток (SSE) = %f\nЧас виконання = %ld мс", res, ten);
	MessageBox(hWnd, TextBuf, "SSE", MB_OK);
}

void myVectFPU(HWND hWnd)

{
	prepare();

	SYSTEMTIME st;
	long tst, ten;
	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute + 1000 * (long)st.wSecond + (long)st.wMilliseconds;

	for (long i = 0; i<1000000; i++) //повторюємо мільйон разів 
	{
		MyDotProduct_FPU(&res, oB, oA, 1000);
	}
	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute + 1000 * (long)st.wSecond + (long)st.wMilliseconds - tst;

	sprintf_s(TextBuf, "Скалярний добуток (FPU) = %f\nЧас виконання = %ld мс", res, ten);
	MessageBox(hWnd, TextBuf, "FPU", MB_OK);

}

float MyDotProduct(float* A, float* B, long N) {
	float result = 0;
	for (long i = 0; i < N; i++) {
		result += A[i] * B[i];
	}
	return result;
}

void vectorCPP(HWND hWnd)

{
	prepare();

	SYSTEMTIME st;
	long tst, ten;
	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute + 1000 * (long)st.wSecond + (long)st.wMilliseconds;

	for (long i = 0; i<1000000; i++)
	{
		res = MyDotProduct(oA, oB, 1000);
	}

	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute + 1000 * (long)st.wSecond + (long)st.wMilliseconds - tst;
	
	sprintf_s(TextBuf, "Скалярний добуток (C++) = %f\nЧас виконання = %ld мс", res, ten);
	MessageBox(hWnd, TextBuf, "C++", MB_OK);

}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  обробляє повідомлення в головному вікні.
//
//  WM_COMMAND - обробка меню програми
//  WM_PAINT - закрасити головне вікно
//  WM_DESTROY - ввести повідомлення про вихід і повернутися.
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;
	PAINTSTRUCT ps;
	HDC hdc;

	switch (message)
	{
	case WM_COMMAND:
		wmId    = LOWORD(wParam);
		wmEvent = HIWORD(wParam);
		// Parse the menu selections:
		switch (wmId)
		{
		case IDM_ABOUT:
			DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
			break;
		case IDM_EXIT:
			DestroyWindow(hWnd);
			break;
		case ID_EXECUTE_SSE:
			myVectSSE(hWnd);
			break;
		case ID_EXECUTE_FPU:
			myVectFPU(hWnd);
			break;
		case ID_EXECUTE_C:
			vectorCPP(hWnd);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
		}
		break;
	case WM_PAINT:
		hdc = BeginPaint(hWnd, &ps);
		// TODO: Add any drawing code here...
		EndPaint(hWnd, &ps);
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

// Оброблювач повідомлень для вікна "Про програму".
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		return (INT_PTR)TRUE;

	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
		{
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}
