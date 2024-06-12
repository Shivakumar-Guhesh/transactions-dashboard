import 'package:flutter/material.dart';

class DropDownMultiCheckbox extends StatefulWidget {
  final List<String> selectedList;
  final List<String> listOFStrings;

  const DropDownMultiCheckbox({
    super.key,
    required this.selectedList,
    required this.listOFStrings,
  });

  @override
  createState() {
    return _DropDownMultiCheckboxState();
  }
}

class _DropDownMultiCheckboxState extends State<DropDownMultiCheckbox> {
  List<String> listOFSelectedItem = [];
  String selectedText = "";

  @override
  void initState() {
    super.initState();
    listOFSelectedItem = widget.selectedList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: SizedBox(
          width: 400,
          child:
              // ExpansionTile(
              //   iconColor: Colors.grey,
              //   title: Text(
              //     listOFSelectedItem.isEmpty ? "Select" : listOFSelectedItem[0],
              //     style: const TextStyle(
              //       color: Colors.grey,
              //       fontWeight: FontWeight.w400,
              //       fontSize: 15.0,
              //     ),
              //   ),
              //   children: <Widget>[
              ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.listOFStrings.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: _ViewItem(
                    item: widget.listOFStrings[index],
                    selected: (val) {
                      selectedText = val;
                      if (listOFSelectedItem.contains(val)) {
                        listOFSelectedItem.remove(val);
                      } else {
                        listOFSelectedItem.add(val);
                      }
                      // widget.selectedList(listOFSelectedItem);
                      setState(() {});
                    },
                    itemSelected: listOFSelectedItem
                        .contains(widget.listOFStrings[index])),
              );
            },
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  final String item;
  final bool itemSelected;
  final Function(String) selected;

  const _ViewItem(
      {required this.item, required this.itemSelected, required this.selected});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * .032, right: size.width * .098),
      child: Row(
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: Checkbox(
              value: itemSelected,
              onChanged: (val) {
                selected(item);
              },
              activeColor: Colors.blue,
            ),
          ),
          SizedBox(
            width: size.width * .025,
          ),
          Text(
            item,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }
}
