import 'package:flutter/material.dart';
import 'shoe_form_page.dart';
import 'db_helper.dart';
import 'shoe.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Shoe>> _shoeList;

  @override
  void initState() {
    super.initState();
    _refreshShoeList();
  }

  void _refreshShoeList() {
    setState(() {
      _shoeList = _fetchShoes();
    });
  }

  Future<List<Shoe>> _fetchShoes() async {
    final allRows = await DBHelper().queryAllRows();
    return allRows.map((row) => Shoe.fromMap(row)).toList();
  }

  void _deleteShoe(int id) async {
    await DBHelper().deleteShoe(id);
    _refreshShoeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: FutureBuilder<List<Shoe>>(
        future: _shoeList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final shoe = snapshot.data![index];
              return ListTile(
                title: Text(shoe.brand),
                subtitle: Text('Size: ${shoe.size} | Buyer: ${shoe.buyerName}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteShoe(shoe.id!),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoeFormPage(shoe: shoe)),
                  ).then((_) => _refreshShoeList());
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoeFormPage()),
          ).then((_) => _refreshShoeList());
        },
      ),
    );
  }
}
