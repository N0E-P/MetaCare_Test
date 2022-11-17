import React from 'react';
import AnimatedText from 'react-animated-text-content';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';
import Head from 'next/head';
import styles from '../styles/Home.module.css';
import { useAccount, usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi';
import contractInterface from '../components/contract-abi.json';
import { useDebounce } from 'usehooks-ts';
import FlipCard, { BackCard, FrontCard } from '../components/FlipCard';


const Home: NextPage = () => {
  const { isConnected } = useAccount();

  // Functions to mint an NFT
  const [doctorAddress, setDoctorAddress] = React.useState('')
  const debouncedDoctorAddress = useDebounce(doctorAddress, 500)
  const { config, error: prepareError,
    isError: isPrepareError, } = usePrepareContractWrite({
    address: '0x0eD2Cb435783140aB9Ea50Dd4bF45dd1c4Ba7620', //ENTER THE SMART CONTRAT ADDRESS HERE
    abi: contractInterface,
    functionName: 'mint',
    args: [debouncedDoctorAddress],
    enabled: Boolean(debouncedDoctorAddress),
  })
  const { data, error, isError, write } = useContractWrite(config);
  const { isLoading, isSuccess } = useWaitForTransaction({
    hash: data?.hash,
  })


  return (
    <div className={styles.container}>
      <Head>
        <title>MetaCare</title>
        <meta
          name="description"
          content="Your Health Data On-Chain"/>
        <link rel="icon" href="/favicon.ico"/>
      </Head>

      <main className={styles.main}>
        <img
                src={"metacarev2cropped.png"}
                width="177px"
                height="192px"
                alt=""
                style={{float: "left"}}/>
        <p className={styles.description}>
        <h2 style={{color:"#091562"}}>A Blockchain-based Healthcare <br></br>Data Management Solution.</h2>
        <h5 style={{color:"#091562"}}>
        <AnimatedText
          type="words" // animate words or chars
          animation={{
            x: '200px',
            y: '-20px',
            scale: 1.1,
            ease: 'ease-in-out',
          }}
          animationType="lights"
          interval={0.06}
          duration={0.8}
          tag="p"
          className="animated-paragraph"
          includeWhiteSpaces
          threshold={0.1}
          rootMargin="20%"
        >
        Track your data. Share it with your doctor. Improve your global health.
        </AnimatedText>
        </h5>
        </p>
        <img className={styles.img}
                src={"blue-men.JPG"}
                width="400px"
                height="700px"
                alt=""
                style={{float: "left"}}
              />
        {!isConnected &&(<h2 style={{color:"#091562"}}>Step 1: Connect your wallet</h2>)}
        {(isConnected && !isSuccess) && (<h2 style={{color:"#091562"}}>Step 2: Mint your NFT</h2>)}
        {(isConnected && isSuccess) &&(<h2 style={{color:"#091562"}}>Step 3: Access your Health Data</h2>)}
        <ConnectButton />
        <h5></h5>

        {(isConnected && !isSuccess) &&(
          <form 
          onSubmit={(e) => {
            e.preventDefault()
            write?.()
          }}>
            <input id="doctorAddress" className={styles.form} onChange={(e) => setDoctorAddress(e.target.value)} placeholder="Doctor's Address" value={doctorAddress}/>
            <button className={styles.button1} disabled={!write || isLoading}>{isLoading ? 'Minting...' : 'Mint Health NFT'}</button>
            
            {(isPrepareError || isError) && (
              <div>Error: {(prepareError || error)?.message}</div>
            )}
          </form>
        )}

        {(isConnected && isSuccess) && (
              <div>
                You Successfully minted your NFT!
                <div>
                  <a className="" href={`https://goerli.etherscan.io/tx/${data?.hash}`}>Etherscan</a>
                  
        <img
                src={"normalHeartRate.png"}
                width="400px"
                height="400px"
                style={{float: "left"}}
              />
                </div>
              </div>
            )}


      </main>

      <footer className={styles.footer}>
        <a href="https://github.com/meta-care" target="_blank" rel="noopener noreferrer">
          Made with 
          <img id="animated" src="heartbeat.gif" width="23px" height="23px" alt=""></img>
          by some frens  
        </a>
      </footer>
    </div>
  );
};

export default Home;
