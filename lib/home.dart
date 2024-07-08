import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  List<Map<String, dynamic>> mahasiswaList = [];
  final supabase = Supabase.instance.client;
  bool isEditing = false;
  dynamic editingId;

  @override
  void initState() {
    super.initState();
    _retrieveMahasiswa();
  }

  void _clearForm() {
    _namaController.clear();
    _jurusanController.clear();
    setState(() {
      isEditing = false;
      editingId = null;
    });
  }

  Future<void> _saveMahasiswa() async {
    if (isEditing) {
      await supabase.from('mahasiswa').update({
        'nama': _namaController.text,
        'jurusan': _jurusanController.text,
      }).eq('id', editingId as Object);
    } else {
      await supabase.from('mahasiswa').insert({
        'nama': _namaController.text,
        'jurusan': _jurusanController.text,
      });
    }
    _clearForm();
    _retrieveMahasiswa();
    Navigator.pop(context); // Close the bottom sheet
  }

  Future<void> _retrieveMahasiswa() async {
    final data = await supabase.from('mahasiswa').select().order('nama');
    setState(() {
      // ignore: unnecessary_cast
      mahasiswaList = data;
    });
  }

  void _deleteMahasiswa(dynamic id) async {
    await supabase.from('mahasiswa').delete().eq('id', id);
    _retrieveMahasiswa();
  }

  void _editMahasiswa(dynamic data) {
    setState(() {
      isEditing = true;
      editingId = data['id'];
      _namaController.text = data['nama'];
      _jurusanController.text = data['jurusan'];
    });
    _showBottomSheet();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: "Nama Mahasiswa",
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _jurusanController,
                decoration: InputDecoration(
                  labelText: "Jurusan Mahasiswa",
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMahasiswa,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  // minimumSize: ,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendataan Mahasiswa"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: mahasiswaList.length,
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswaList[index];
          return Card(
            color: Colors.lightBlue[100],
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(mahasiswa['nama']),
              subtitle: Text(mahasiswa['jurusan']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black54),
                    onPressed: () => _editMahasiswa(mahasiswa),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.black54),
                    onPressed: () => _deleteMahasiswa(mahasiswa['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheet,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
