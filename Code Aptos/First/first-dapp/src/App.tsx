import React from 'react';
import './App.css';
import { Types, AptosClient } from 'aptos';
const client = new AptosClient('https://fullnode.devnet.aptoslabs.com/v1');

// # Basic

function App() {
  const [address, setAddress] = React.useState<string | null>(null);

  // Lấy data
  const init = async() => {
    const { address, publicKey } = await window.aptos.connect();
    setAddress(address);
  }

  const [account, setAccount] = React.useState<Types.AccountData | null>(null);
  React.useEffect(() => {
    if (!address) return;
    client.getAccount(address).then(setAccount);
  }, [address]);
  
  React.useEffect(() => {
    init();
  }, []);

  // Lấy module
  const [modules, setModules] = React.useState<Types.MoveModuleBytecode[]>([]);
  React.useEffect(() => {
    if (!address) return;
    client.getAccountModules(address).then(setModules);
  }, [address]);

  const hasModule = modules.some((m) => m.abi?.name === 'message');
  const publishInstructions = (
    <pre>
      Run this command to publish the module:
      <br />
      aptos move publish --package-dir /path/to/hello_blockchain/
      --named-addresses hello_blockchain={address}
    </pre>
  );

  // Tạo tx
  const ref = React.createRef<HTMLTextAreaElement>();
  const [isSaving, setIsSaving] = React.useState(false);
  const handleSubmit = async (e: any) => {
    e.preventDefault();
    if (!ref.current) return;
    const message = ref.current.value;
    const transaction = {
      type: "entry_function_payload",
      function: `${address}::message::set_message`,
      arguments: [message],
      type_arguments: [],
    };
    try {
      setIsSaving(true);
      await window.aptos.signAndSubmitTransaction(transaction);
    } finally {
      setIsSaving(false);
    }
  };

  // Đọc state của 1 address bất kỳ
  const [resources, setResources] = React.useState<Types.MoveResource[]>([]);
  React.useEffect(() => {
    if (!address) return;
    client.getAccountResources(address).then(setResources);
  }, [address]);
  const resourceType = `${address}::message::MessageHolder`;
  const resource = resources.find((r) => r.type === resourceType);
  const data = resource?.data as {message: string} | undefined;
  const message = data?.message;

  return (
    <>
      <div className="App">
        <p>Account Address: <code>{ address }</code></p>
        <p>Sequence Number: <code>{ account?.sequence_number } represents the next transaction sequence number to prevent replay attacks of transactions</code></p>
      </div>
      {!hasModule && publishInstructions}
      <div className="App">
        {hasModule ? (
          <form onSubmit={handleSubmit}>
            <p>On-chain message</p>
            <textarea ref={ref} defaultValue={message} />
            <input disabled={isSaving} type="submit" />
          </form>
        ) : publishInstructions}
      </div>
    </>
  );
}

export default App;