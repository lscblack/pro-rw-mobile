import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 1, 33, 59),
        title: Center(
            child: Text(
          "PRO RW ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection("Questions")
            .snapshots(), // Listen for changes
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Questions found"));
          }

          var products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q.${index + 1}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                        width:
                            8), // Add some spacing between the text and the image
                    Expanded(
                      child: Text(
                        product["question"],
                        softWrap: true, // Enable text wrapping
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(left: 40,top:10),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    product["ans"].length,
                    (ansIndex) {
                      var answer = product["ans"][ansIndex];
                      if (answer["correctness"] == "correct") {
                        return Text(
                          // textAlign: TextAlign.left,
                          "${answer["ans"]} - Correctness: ${answer["correctness"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              fontSize: 11, color: const Color.fromARGB(255, 28, 173, 33)),
                        );
                      }
                      else{
                      return Text(
                        // textAlign: TextAlign.left,
                        "${answer["ans"]} - Correctness: ${answer["correctness"]}",
                        style: TextStyle(fontSize: 10, color: Colors.red),
                      );

                      }
                    },
                  ),
                ),),
              );
            },
          );
        },
      ),
    );
  }
}
