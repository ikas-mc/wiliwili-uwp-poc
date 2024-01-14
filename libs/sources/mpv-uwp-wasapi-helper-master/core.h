#pragma once
#include <mmdeviceapi.h>

#include <wrl.h>
#include <mfapi.h>
#include <AudioClient.h>

using namespace Microsoft::WRL;

extern "C" {
	__declspec(dllexport) HRESULT wuCreateDefaultAudioRenderer(IUnknown **res);
}
