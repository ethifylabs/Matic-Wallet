import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
class EthWrapper{
  final rootChainAddress = "0x60e2b19b9a87a3f37827f2c8c8306be718a5f9b4";
  final moonRopsten = "0x48b0c1d90c3058ab032c44ec52d98633587ee711";
  Future<String> checkBalanceRopsten()async{
    double retbal;
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/StandardToken.json').then((abi)async{
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex("0x48b0c1d90c3058ab032c44ec52d98633587ee711"));
        var balance = contract.function('balanceOf');
        await client.call(
          contract: contract,
          function: balance ,
          params: [address],
        ).then((balance){
          print(balance);
          print(balance.first);
          BigInt vr = BigInt.from(balance.first/BigInt.from(1000000000000000));

          double bal = vr.toDouble()/1000.0;
          print("bal:"+bal.toString());
          retbal=bal;
        });
      });
    });
    await client.dispose();
    return retbal.toString();

  }
  Future<String> checkBalanceMatic()async{
    double retbal;
    var apiUrl = "https://testnet2.matic.network";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/StandardToken.json').then((abi)async{
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex("0xb35456a9b634cf85569154321596ee2d62e215ba"));
        var balance = contract.function('balanceOf');
        await client.call(
          contract: contract,
          function: balance ,
          params: [address],
        ).then((balance){
          print(balance);
          print(balance.first);
          BigInt vr = BigInt.from(balance.first/BigInt.from(1000000000000000));

          double bal = vr.toDouble()/1000.0;
          print("bal:"+bal.toString());
          retbal=bal;
        });
      });
    });
    await client.dispose();
    return retbal.toString();

  }
  Future<bool> transferToken(String recipient, double amount)async{
    const apiUrl = "https://testnet2.matic.network";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString("assets/StandardToken.json").then((abi)async{
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex("0xb35456a9b634cf85569154321596ee2d62e215ba"));
        var transfer = contract.function('transfer');
        await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: transfer,
              parameters: [EthereumAddress.fromHex(recipient),BigInt.from(amount*1000)*BigInt.from(1000000000000000)]
          ),
          chainId: 8995,

        ).then((hash){
          print(BigInt.from(amount)*BigInt.from(1000000000000000000));
          print("tx hash: "+ hash);

        });
      });
    });
    await client.dispose();
    return true;
  }
  Future<dynamic> approveToken(double amount) async {
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/StandardToken.json').then((abi)async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        print(BigInt.from(amount*1000)*BigInt.from(1000000000000000));
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(moonRopsten));
        print(contract.abi.toString());
        print(contract.address);
        var appr = contract.function('approve');

        var txhash =await client.sendTransaction(
            credentials,
            Transaction.callContract(
                contract: contract,
                function: appr,
                //nonce: Random.secure().nextInt(100),
                gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
                maxGas: 5000000,
                parameters: [EthereumAddress.fromHex(rootChainAddress),BigInt.from(amount*1000)*BigInt.from(1000000000000)]
            ),
            chainId: 3,

          );
       // await client.dispose();
        print("completing approve:"+txhash );
        return txhash;

      });

    });

  }
  Future<dynamic> allowanceToken() async {
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/StandardToken.json').then((abi)async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(moonRopsten));
        print(contract.abi.toString());
        print(contract.address);
        var allow = contract.function('increaseAllowance');

        var txhash =await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: allow,
              //nonce: Random.secure().nextInt(100),
              gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
              maxGas: 7000000,
              parameters: [EthereumAddress.fromHex(rootChainAddress),BigInt.from(999999*1000)*BigInt.from(1000000000000)]
          ),
          chainId: 3,

        );
       // await client.dispose();
        print("completing allow:"+txhash );
        return txhash;

      });

    });

  }
  Future<dynamic> depositERC20 (double amount)async {

    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client(), enableBackgroundIsolate: true);
    rootBundle.loadString('assets/RootChain.json').then((abi) async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract = DeployedContract(
            ContractAbi.fromJson(abi, "RootChain"),
            EthereumAddress.fromHex(rootChainAddress));
        var deposit = contract.function('deposit');
        var txhash =await client.sendTransaction(
              credentials,
              Transaction.callContract(
                  contract: contract,
                  function: deposit,
                 // nonce: Random.secure().nextInt(100),
                  gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
                  maxGas: 4000000,
                  parameters: [
                    EthereumAddress.fromHex(moonRopsten),
                    address,
                    BigInt.from(amount * 1000) * BigInt.from(1000000000000000)
                  ]
              ),

              chainId: 3,

            );
        //await client.dispose().then((xc){
          print("completing deposit:"+txhash );
          return txhash;
        //});


      });
    });

  }
  Future<BigInt> checkEth()async{
    BigInt retbal;
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        var bal =await client.getBalance(address);
        BigInt abc = bal.getInWei;
        retbal = abc;
      });
    await client.dispose();
    return retbal;

  }
}

