import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Material Design - 4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // For qr code view
  final GlobalKey _globalKey = GlobalKey();
  QRViewController? qrViewController;
  Barcode? result;

  void qr(QRViewController qrViewController) {
    this.qrViewController = qrViewController;
    qrViewController.scannedDataStream.listen((event) {
      setState(() {
        result = event;
      });
    });
  }

  int _currentPageIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      setState(() {
        _currentPageIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TabBarView(
          controller: _tabController,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/post_1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Builder(builder: (context) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: 50,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'This cat is wonderful',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: const Text(
                              'Click to read more',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  Expanded(
                    child: QRView(
                      key: _globalKey,
                      onQRViewCreated: qr,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Center(
                      child: (result != null)
                          ? Text('${result!.code}')
                          : const Text('Scan a code'),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Hero(
                        tag: 'avatar',
                        child: Image.asset('assets/images/ava.jpg'),
                      ),
                    ),
                  );
                }));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Hero(
                    tag: 'avatar',
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage('assets/images/ava.jpg'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Student: Adam',
                    style: TextStyle(fontSize: 24),
                  ),
                FloatingActionButton(
                  onPressed: _showToast,
                  child: const Icon(Icons.add),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/post_1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              height: 200,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Cats are wonderful creatures that bring joy to many people. They are known for their playful and affectionate personalities, and are often kept as pets in households around the world.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentPageIndex = newIndex;
            _tabController.animateTo(_currentPageIndex);
          });
        },
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'QR', icon: Icon(Icons.qr_code)),
          BottomNavigationBarItem(label: 'Person', icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Empat learning",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
