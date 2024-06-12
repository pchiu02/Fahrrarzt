import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class AuftrageAnsehen extends StatefulWidget {
  const AuftrageAnsehen({Key? key}) : super(key: key);

  @override
  State<AuftrageAnsehen> createState() => _AuftrageAnsehenState();
}

class _AuftrageAnsehenState extends State<AuftrageAnsehen> {
  @override
  Widget build(BuildContext context) {
    var bodyStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'InterRegular',
        );
    Color primaryColor = lightColorScheme.primary;
    Color bgColor = lightColorScheme.background;
    Color secondaryColor = Color.fromARGB(245, 245, 245, 245);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'FAHRRARZT',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            letterSpacing: 2.0,
            color: bgColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Meine Reparaturen',
                  style: TextStyle(fontSize: 26),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('booking')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading');
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot booking = snapshot.data!.docs[index];
                          final data = booking.data() as Map<String, dynamic>;
                          if (data.containsKey('chosen') && (booking['chosen'] as bool? ?? false)) {}
                          return Container();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Available Bookings', style: TextStyle(fontSize: 26)),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('booking')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading');
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot booking = snapshot.data!.docs[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            margin: EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Color(0xFF7553F6),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Name: ${booking['name']}',
                                    style: bodyStyle),
                                Text('Booking ID: ${booking.id}',
                                    style: bodyStyle),
                                Text('Price: ${booking['price']}',
                                    style: bodyStyle),
                                Text(
                                    'Component: ${booking['komponente'].join(', ')}',
                                    style: bodyStyle),
                                Text(
                                    'Zubehor: ${booking['zubehoer'].join(', ')}',
                                    style: bodyStyle),
                                Text('Status: ${booking['status']}',
                                    style: bodyStyle),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Choose Booking'),
                                              content: const Text(
                                                  'Do you want to choose this booking?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('booking')
                                                        .doc(booking.id)
                                                        .update({
                                                      'chosen': true,
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Confirm'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'Choose',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontFamily: 'Poppins-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
