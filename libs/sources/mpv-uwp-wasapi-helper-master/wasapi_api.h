#pragma once
#include "pch.h"

// (Unclear copyright.)

MIDL_INTERFACE("D666063F-1587-4E43-81F1-B948E807363F")
IMMDevice : public IUnknown
{
public:
	virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Activate(
		/* [annotation][in] */
		_In_  REFIID iid,
		/* [annotation][in] */
		_In_  DWORD dwClsCtx,
		/* [annotation][unique][in] */
		_In_opt_  PROPVARIANT *pActivationParams,
		/* [annotation][iid_is][out] */
		_Out_  void **ppInterface) = 0;

	virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE OpenPropertyStore(
		/* [annotation][in] */
		_In_  DWORD stgmAccess,
		/* [annotation][out] */
		_Out_  IPropertyStore **ppProperties) = 0;

	virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetId(
		/* [annotation][out] */
		_Outptr_  LPWSTR *ppstrId) = 0;

	virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE GetState(
		/* [annotation][out] */
		_Out_  DWORD *pdwState) = 0;

};
