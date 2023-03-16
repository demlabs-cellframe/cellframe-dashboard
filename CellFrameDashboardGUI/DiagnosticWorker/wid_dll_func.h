#ifndef WID_DLL_FUNC_H
#define WID_DLL_FUNC_H

#if defined(BUILD_DLL)
#define DLL_EXP __declspec(dllexport)
#else
#if defined(BUILD_APP)
#define DLL_EXP __declspec(dllimport)
#else
#define DLL_EXP
#endif
#endif

DLL_EXP wchar_t** PrintVersionStringInfo(wchar_t* fileName);

DLL_EXP int sum(int a, int b);

#endif  // WID_DLL_FUNC_H
