#include "pch.h"
#include "core.h"

using namespace Platform;
using namespace Windows::Media::Devices;


class DeviceCreator : public RuntimeClass< RuntimeClassFlags< ClassicCom >, FtmBase, IActivateAudioInterfaceCompletionHandler >
{
	HANDLE m_event;
public:
	HRESULT result = E_FAIL;
	IUnknown *ptr = nullptr;
	bool done;

	DeviceCreator()
	{
		m_event = CreateEvent(nullptr, TRUE, FALSE, nullptr);
	}
	virtual ~DeviceCreator()
	{
		CloseHandle(m_event);
	}

	void startCreate()
	{
		IActivateAudioInterfaceAsyncOperation *asyncOp;

		HRESULT hr = S_OK;
		Platform::String^ deviceID = MediaDevice::GetDefaultAudioRenderId(Windows::Media::Devices::AudioDeviceRole::Default);

		// This call must be made on the main UI thread.  Async operation will call back to 
		// IActivateAudioInterfaceCompletionHandler::ActivateCompleted, which must be an agile interface implementation

		hr = ActivateAudioInterfaceAsync(deviceID->Data(), __uuidof(IAudioClient3), nullptr, this, &asyncOp);
		if (FAILED(hr))
		{
			notifyResult(hr, nullptr);
		}
	}

	// Inherited via RuntimeClass
	virtual HRESULT STDMETHODCALLTYPE ActivateCompleted(IActivateAudioInterfaceAsyncOperation * activateOperation) override
	{
		HRESULT hr = S_OK;
		HRESULT hrActivateResult = S_OK;
		IUnknown *punkAudioInterface = nullptr;

		hr = activateOperation->GetActivateResult(&hrActivateResult, &punkAudioInterface);
		if (SUCCEEDED(hr)) {
			if (SUCCEEDED(hrActivateResult)) {
				notifyResult(hr, punkAudioInterface);
				punkAudioInterface->Release();
			}
			else 
			{
				notifyResult(hrActivateResult, nullptr);
			}
		}
		else
		{
			notifyResult(hr, nullptr);
		}

		return S_OK;
	}

	void notifyResult(HRESULT hr, IUnknown *ptr)
	{
		this->result = hr;
		this->ptr = ptr;
		if (this->ptr)
			this->ptr->AddRef();
		this->done = true;
		// (in theory we'd need a memory barrier)
		SetEvent(m_event);
	}

	void wait()
	{
		WaitForSingleObject(m_event, INFINITE);
	}
};

HRESULT wuCreateDefaultAudioRenderer(IUnknown **res)
{
	auto creator = Make<DeviceCreator>();
	creator->startCreate();
	creator->wait();
	if (SUCCEEDED(creator->result)) {
		*res = creator->ptr;
		(*res)->AddRef();
	}
	return creator->result;
}


#if 0

#include <wrl/client.h>
#include <wrl/wrappers/corewrappers.h>
#include <windows.ui.core.h>

using namespace Microsoft::WRL; 
using namespace Microsoft::WRL::Wrappers; 
using namespace ABI::Windows::ApplicationModel::Core; 
using namespace ABI::Windows::UI::Core;

void getShit()
{
	ComPtr<ABI::Windows::ApplicationModel::Core::ICoreApplication> appStatics;
	HRESULT hr = RoGetActivationFactory(HString::MakeReference(RuntimeClass_Windows_ApplicationModel_Core_CoreApplication).Get(), IID_PPV_ARGS(&appStatics));
	if (SUCCEEDED(hr)) {
		ComPtr<ABI::Windows::ApplicationModel::Core::ICoreApplicationView> currentView;
		hr = appStatics->GetCurrentView(&currentView);
		if (SUCCEEDED(hr))
		{
			ComPtr<ABI::Windows::ApplicationModel::Core::ICoreApplicationView2> currentView2;
			hr = currentView.As(&currentView2);
			if (SUCCEEDED(hr))
			{
				ComPtr<ABI::Windows::UI::Core::ICoreDispatcher> dispatcher;
				hr = currentView2->get_Dispatcher(&dispatcher);
				if (SUCCEEDED(hr))
				{

					// TODO: https://stackoverflow.com/questions/28246848/what-is-dispatchedhandler-and-how-to-use-it-in-abi +          
					//hr = dispatcher->RunAsync(CoreDispatcherPriority_Normal, ...);
				}
			}
		}
	}
}

#endif