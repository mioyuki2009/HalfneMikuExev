#include "Texture2DDx12.h"
#include <string>
#include <fstream>
#include <assert.h>
#include <d3dcompiler.h>
#include "d3dx12.h"
#include "Windows/MWindow.h"
#include <directxmath.h>

ID3D12RootSignature* rootSignature = nullptr;
ID3D12PipelineState* pipelineStateObject = nullptr;
ID3D12Resource* vertexBuffer = nullptr;

CD3DX12_VIEWPORT viewport(0.0f, 0.0f, 1280.0f, 800.0f);
CD3DX12_RECT scissorRect(0, 0, 1280.0f, 800.0f);

D3D12_VERTEX_BUFFER_VIEW vertexBufferView;

bool LoadShaderBinary(ID3DBlob* blob, const std::string filename);

struct Vertex {
    DirectX::XMFLOAT3 pos;
    DirectX::XMFLOAT4 color;
};

MaterialTexture2D::MaterialTexture2D()
{
	//const auto& windowimpl = std::static_pointer_cast<MWindows>(MWindows::Get());
	const auto& dx12impl = std::static_pointer_cast<MDx12>(GraphImpl::Get());

	const auto& device = dx12impl->GetDevice();
    const auto& commandList = dx12impl->GetCommandList();
    const auto& commandQueue = dx12impl->GetCommandQueue();
        
	HRESULT hr = S_OK;
	CD3DX12_ROOT_SIGNATURE_DESC rootSignatureDesc;
	rootSignatureDesc.Init(0, nullptr, 0, nullptr, D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	ID3DBlob* signature;
	hr = D3D12SerializeRootSignature(&rootSignatureDesc, D3D_ROOT_SIGNATURE_VERSION_1, &signature, nullptr);
	assert(hr == S_OK);
	hr = device->CreateRootSignature(0, signature->GetBufferPointer(), signature->GetBufferSize(), IID_PPV_ARGS(&rootSignature));
	assert(hr == S_OK);

	DXGI_SAMPLE_DESC sampleDesc = {};
	sampleDesc.Count = 1; // multisample count (no multisampling, so we just put 1, since we still need 1 sample)

	static const char* vertexFile = "";
	static const char* pixelFile = "";
	
    UINT compileFlags = D3DCOMPILE_DEBUG | D3DCOMPILE_SKIP_OPTIMIZATION;
	//assert(LoadShaderBinary(vertexShader, vertexFile));
	//assert(LoadShaderBinary(pixelShader, pixelFile));
    D3DCompileFromFile(L"shaders.hlsl", nullptr, nullptr, "VSMain", "vs_5_0", compileFlags, 0, &vertexShader, nullptr);
    D3DCompileFromFile(L"shaders.hlsl", nullptr, nullptr, "PSMain", "ps_5_0", compileFlags, 0, &pixelShader, nullptr);


	D3D12_SHADER_BYTECODE vertexShaderBytecode = {};
	vertexShaderBytecode.BytecodeLength = vertexShader->GetBufferSize();
	vertexShaderBytecode.pShaderBytecode = vertexShader->GetBufferPointer();

	D3D12_SHADER_BYTECODE pixelShaderBytecode = {};
	pixelShaderBytecode.BytecodeLength = pixelShader->GetBufferSize();
	pixelShaderBytecode.pShaderBytecode = pixelShader->GetBufferPointer();

	D3D12_INPUT_ELEMENT_DESC inputLayout[] =
	{
        { "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
        { "COLOR", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 }
    };

    D3D12_GRAPHICS_PIPELINE_STATE_DESC psoDesc = {};
    psoDesc.InputLayout = { inputLayout, _countof(inputLayout) };
    psoDesc.pRootSignature = rootSignature;
    psoDesc.VS = CD3DX12_SHADER_BYTECODE(vertexShader);
    psoDesc.PS = CD3DX12_SHADER_BYTECODE(pixelShader);
    psoDesc.RasterizerState = CD3DX12_RASTERIZER_DESC(D3D12_DEFAULT);
    psoDesc.BlendState = CD3DX12_BLEND_DESC(D3D12_DEFAULT);
    psoDesc.DepthStencilState.DepthEnable = FALSE;
    psoDesc.DepthStencilState.StencilEnable = FALSE;
    psoDesc.SampleMask = UINT_MAX;
    psoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
    psoDesc.NumRenderTargets = 1;
    psoDesc.RTVFormats[0] = DXGI_FORMAT_R8G8B8A8_UNORM;
    psoDesc.SampleDesc.Count = 1;

    // create the pso
	hr = device->CreateGraphicsPipelineState(&psoDesc, IID_PPV_ARGS(&pipelineStateObject));
	assert(hr == S_OK);

    // Create vertex buffer
    float aspec = 1280.0f / 800.0f;
    // a triangle
    Vertex triangleVertices[] =
    {
        { { 0.0f, 0.25f * aspec, 0.0f }, { 1.0f, 0.0f, 0.0f, 1.0f } },
        { { 0.25f, -0.25f * aspec, 0.0f }, { 0.0f, 1.0f, 0.0f, 1.0f } },
        { { -0.25f, -0.25f * aspec, 0.0f }, { 0.0f, 0.0f, 1.0f, 1.0f } }
    };

    int vBufferSize = sizeof(triangleVertices);
    // store vertex buffer in upload heap
    D3D12_SUBRESOURCE_DATA vertexData = {};
    vertexData.pData = reinterpret_cast<BYTE*>(triangleVertices); // pointer to our vertex array
    vertexData.RowPitch = vBufferSize; // size of all our triangle vertex data
    vertexData.SlicePitch = vBufferSize; // also the size of our triangle vertex data

    device->CreateCommittedResource(
        &CD3DX12_HEAP_PROPERTIES(D3D12_HEAP_TYPE_UPLOAD),
        D3D12_HEAP_FLAG_NONE,
        &CD3DX12_RESOURCE_DESC::Buffer(vBufferSize),
        D3D12_RESOURCE_STATE_GENERIC_READ,
        nullptr,
        IID_PPV_ARGS(&vertexBuffer));

    // Copy the triangle data to the vertex buffer.
    UINT8* pVertexDataBegin;
    CD3DX12_RANGE readRange(0, 0);        // We do not intend to read from this resource on the CPU.
    vertexBuffer->Map(0, &readRange, reinterpret_cast<void**>(&pVertexDataBegin));
    memcpy(pVertexDataBegin, triangleVertices, sizeof(triangleVertices));
    vertexBuffer->Unmap(0, nullptr);

    // Now we execute the command list to upload the initial assets (triangle data)
    commandList->Close();
    ID3D12CommandList* ppCommandLists[] = { commandList };
    commandQueue->ExecuteCommandLists(_countof(ppCommandLists), ppCommandLists);
    // create a vertex buffer view for the triangle. We get the GPU memory address to the vertex pointer using the GetGPUVirtualAddress() method
    vertexBufferView.BufferLocation = vertexBuffer->GetGPUVirtualAddress();
    vertexBufferView.StrideInBytes = sizeof(Vertex);
    vertexBufferView.SizeInBytes = vBufferSize;

    MDx12::WaitForLastSubmittedFrame();

    dx12impl->Register(this);
}

void MaterialTexture2D::ProcessCommandList(ID3D12GraphicsCommandList* pCommandList, ID3D12Resource* pRenderTarget, ID3D12DescriptorHeap* pDescriptorHeap, 
    unsigned int frameIndex,unsigned int rtvDescriptorSize)
{
    pCommandList->SetPipelineState(pipelineStateObject);
  
    // Set necessary state.
    pCommandList->SetGraphicsRootSignature(rootSignature);
    pCommandList->RSSetViewports(1, &viewport);
    pCommandList->RSSetScissorRects(1, &scissorRect);

    // Indicate that the back buffer will be used as a render target.
    pCommandList->ResourceBarrier(1, &CD3DX12_RESOURCE_BARRIER::Transition(pRenderTarget, D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_RENDER_TARGET));

    CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHandle(pDescriptorHeap->GetCPUDescriptorHandleForHeapStart(), frameIndex, rtvDescriptorSize);
    pCommandList->OMSetRenderTargets(1, &rtvHandle, FALSE, nullptr);

    // Record commands.
    const float clearColor[] = { 0.0f, 0.2f, 0.4f, 1.0f };
    pCommandList->ClearRenderTargetView(rtvHandle, clearColor, 0, nullptr);
    pCommandList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    pCommandList->IASetVertexBuffers(0, 1, &vertexBufferView);
    pCommandList->DrawInstanced(3, 1, 0, 0);

    // Indicate that the back buffer will now be used to present.
    pCommandList->ResourceBarrier(1, &CD3DX12_RESOURCE_BARRIER::Transition(pRenderTarget, D3D12_RESOURCE_STATE_RENDER_TARGET, D3D12_RESOURCE_STATE_PRESENT));
    pCommandList->Close();
}

bool LoadShaderBinary(ID3DBlob* blob, const std::string filename)
{
	std::ifstream fin(filename, std::ios::binary);
	
	fin.seekg(0, std::ios_base::end);
	std::ifstream::pos_type size = (int)fin.tellg();
	fin.seekg(0, std::ios_base::beg);
	assert(S_OK == D3DCreateBlob(size, &blob));
	fin.read((char*)blob->GetBufferPointer(), size);
	fin.close();

	return true;
}