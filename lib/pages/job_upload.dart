// import 'dart:convert';

// import 'package:Yujai/models/industry.dart';
// import 'package:Yujai/models/location.dart';
// import 'package:Yujai/resources/repository.dart';
// import 'package:Yujai/widgets/progress.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:core';
// import '../style.dart';
// import 'home.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// // ignore: must_be_immutable
// class JobPost extends StatefulWidget {
//   @override
//   _JobPostState createState() => _JobPostState();
// }

// class Category {
//   int id;
//   String name;
//   Category(this.id, this.name);
//   static List<Category> getCategory() {
//     return <Category>[
//       Category(1, "Information Technology and Services"),
//       Category(2, "Hospital & Health Care"),
//       Category(3, "Construction"),
//       Category(4, "Education Management"),
//       Category(5, "Retail"),
//       Category(6, "Financial Services"),
//       Category(7, "Accounting"),
//       Category(8, "Computer Software"),
//       Category(9, "Automotive"),
//       Category(10, "Higher Education"),
//       Category(11, "Marketing & Advertising"),
//       Category(12, "Government Administration"),
//       Category(13, "Banking"),
//       Category(14, "Health, Welness & Fitness"),
//       Category(15, "Telecommunications"),
//       Category(16, "Oil & Energy"),
//       Category(17, "Food & Beverages"),
//       Category(18, "Hospitality"),
//       Category(19, "Mechanical or Industrial Engineering"),
//       Category(20, "Electrical & Electronic Manufacturing"),
//       Category(21, "Primary/Secondary Education"),
//       Category(22, "Insurance"),
//       Category(23, "Internet"),
//       Category(24, "Human Resources"),
//       Category(25, "Medical Practice"),
//       Category(26, "Transportation/Trucking/Railroad"),
//       Category(27, "Consumer Services"),
//       Category(28, "Management Consulting"),
//       Category(29, "Pharmaceuticals"),
//       Category(30, "Civil Engineering"),
//       Category(31, "Design"),
//       Category(31, "Research"),
//       Category(32, "Restaurants"),
//       Category(33, "Logistics & Supply Chain"),
//       Category(34, "Architecture & Planning"),
//       Category(35, "Law Practice"),
//       Category(36, "Apparel & Fashion"),
//       Category(37, "Consumer Goods"),
//       Category(38, "Facilities Services"),
//       Category(39, "Food Production"),
//       Category(40, "Non-profit Organization Management"),
//       Category(41, "Entertainment"),
//       Category(42, "Machinery"),
//       Category(43, "Chemicals"),
//       Category(44, "Arts & Crafts"),
//       Category(45, "Wholesale"),
//       Category(46, "Utilities"),
//       Category(47, "Legal Services"),
//       Category(48, "Farming"),
//       Category(50, "Mining & Metals"),
//       Category(51, "Airlines/Aviation"),
//       Category(52, "Leisure, Travel & Turism"),
//       Category(53, "Sporting Goods"),
//       Category(54, "Building Materials"),
//       Category(55, "Music"),
//       Category(56, "Enviromental Services"),
//       Category(57, "Professional Training & Coaching"),
//       Category(58, "Medical Device"),
//       Category(59, "Indil & Family Services"),
//       Category(60, "Cosmetics"),
//       Category(61, "Mental Health Care"),
//       Category(62, "Aviation and Aerospace"),
//       Category(63, "Staffing & Recruiting"),
//       Category(64, "Industrial Automation"),
//       Category(65, "Graphic Design"),
//       Category(66, "Security & Investigations"),
//       Category(67, "Import and Export"),
//       Category(68, "Public Relations and Communications"),
//       Category(69, "Textiles"),
//       Category(70, "Military"),
//       Category(71, "Broadcast Media"),
//       Category(72, "Biotechnology"),
//       Category(73, "Media Production"),
//       Category(74, "Computer Networking"),
//       Category(75, "Writing & Editing"),
//       Category(76, "Consumer Elecronics"),
//       Category(77, "International Trade and Development"),
//       Category(78, "Events Services"),
//       Category(79, "Photography"),
//       Category(80, "Renewables & Envirnoment"),
//       Category(83, "Computer Hardware"),
//       Category(84, "Civic and Social Organization"),
//       Category(85, "Furniture"),
//       Category(86, "Defense & Space"),
//       Category(87, "Computer & Network Security"),
//       Category(88, "Printing"),
//       Category(89, "Fine Art"),
//       Category(90, "Religious Institutions"),
//       Category(91, "Investmend Management"),
//       Category(92, "Law Enforcement"),
//       Category(93, "Publishing"),
//       Category(94, "Information Services"),
//       Category(95, "Maritime"),
//       Category(96, "Warehousing"),
//       Category(97, "E-learning"),
//       Category(98, "Executive Office"),
//       Category(99, "Government Relations"),
//       Category(100, "Semiconducs"),
//       Category(101, "Supermarkets"),
//       Category(102, "Program Development"),
//       Category(103, "Public Safety"),
//       Category(104, "Plastics"),
//       Category(105, "Alternative Medicine"),
//       Category(106, "Performing Arts"),
//       Category(107, "Online Media"),
//       Category(108, "Motion Pictures & Film"),
//       Category(109, "Judiciary"),
//       Category(110, "Packaging and Containers"),
//       Category(111, "Luxury Goods & Jewelry"),
//       Category(112, "Veterinary"),
//       Category(113, "Computer Games"),
//       Category(114, "Investment Banking"),
//       Category(115, "Market Research"),
//       Category(116, "International Affairs"),
//       Category(117, "Wine & Spirits"),
//       Category(118, "Newspapers"),
//       Category(119, "Translation & Localisation"),
//       Category(120, "Recreational Facilities & Services"),
//       Category(121, "Sporting Goods"),
//       Category(122, "Paper & Forest Products"),
//       Category(123, "Capital Markets"),
//       Category(124, "Public Policy"),
//       Category(125, "Package/Freight Delivery"),
//       Category(126, "Libraries"),
//       Category(127, "Wireless"),
//       Category(128, "Gambling & Casinos"),
//       Category(129, "Venture Capital & Private Equity"),
//       Category(130, "Glass, Ceramics & Concrete"),
//       Category(131, "Philanthropy"),
//       Category(132, "Ranching"),
//       Category(133, "Dairy"),
//       Category(134, "Museums and Institutions"),
//       Category(135, "Shipbuilding"),
//       Category(136, "Think Thanks"),
//       Category(137, "Political Organization"),
//       Category(138, "Fishery"),
//       Category(139, "Fund-Raising"),
//       Category(140, "Tobacco"),
//       Category(141, "Railroad Manufacture"),
//       Category(142, "Alternative Dispute Resolution"),
//       Category(143, "Nanotechnology"),
//       Category(144, "Legislative Office"),
//       Category(145, "Film"),
//       Category(146, "Trading"),
//       Category(147, "IT Enabled Services"),
//       Category(149, "Learning & Education"),
//       Category(150, "Gems and Jewellery"),
//       Category(151, "Metals - Ferrous"),
//       Category(152, "Apparels"),
//       Category(153, "Fertilisers"),
//       Category(154, "General"),
//       Category(155, "Industrial Consumables"),
//       Category(156, "Metals - Non Ferrous"),
//       Category(157, "Tea / Coffee"),
//       Category(158, "Defence"),
//       Category(159, "Real Estate"),
//       Category(160, "Miscellaneous"),
//       Category(161, "Auto Ancillaries"),
//       Category(162, "Services"),
//       Category(163, "Cables"),
//       Category(164, "Power"),
//       Category(165, "Cement"),
//       Category(166, "Petrochemicals"),
//       Category(167, "Infrastructure"),
//       Category(168, "Engineering"),
//       Category(169, "Diversified"),
//       Category(170, "Tourism & Hospitality"),
//       Category(171, "Logistics"),
//       Category(172, "Auto"),
//       Category(173, "Agro Processing"),
//       Category(174, "Media & Entertainment"),
//       Category(175, "Mining"),
//       Category(176, "Tyres"),
//       Category(177, "Banks"),
//       Category(178, "Electric/Electronics"),
//       Category(179, "Leather"),
//       Category(180, "Shipping"),
//       Category(181, "IT Software"),
//       Category(182, "Packaging"),
//       Category(183, "Consumer Durables"),
//       Category(184, "Building Materials"),
//       Category(185, "Sugar"),
//       Category(186, "Beverages - Alcoholic"),
//       Category(187, "Chemicals"),
//       Category(188, "Holding Company"),
//       Category(189, "Plastics"),
//       Category(191, "NBFC"),
//       Category(192, "Retail"),
//       Category(193, "Financial Services"),
//       Category(194, "Hospitals & Allied Services"),
//       Category(195, "InvIT"),
//       Category(196, "Pharmaceuticals"),
//       Category(197, "Construction"),
//       Category(198, "Textiles"),
//       Category(199, "IT - Hardware"),
//       Category(200, "Agriculture/Horticulture/Livestock"),
//       Category(201, "Term Lending Institutions"),
//       Category(202, "FMCG"),
//       Category(203, "Glass"),
//       Category(204, "Airlines"),
//       Category(205, "Aquaculture"),
//       Category(206, "Telecommunications"),
//       Category(207, "Industrial Equipment"),
//       Category(208, "Irrigation & Allied Services"),
//       Category(209, "Gas & Petroleum"),
//       Category(210, "Paper"),
//       Category(211, "Pesti/Agro Chemicals"),
//       Category(212, "Rubber"),
//       Category(213, "Automobile Industry"),
//       Category(214, "Biscuits Industry in India"),
//       Category(215, "Confederation of Indian Industry"),
//       Category(216, "Cottage industries"),
//       Category(217, "Fertilizer Industry in India"),
//       Category(218, "Hotel Industry in India"),
//       Category(219, "India Basic Metals Industry"),
//       Category(220, "India Heavy Chemical Industry"),
//       Category(222, "Indian Banking Industry"),
//       Category(223, "Indian Bus Industry"),
//       Category(224, "Indian Handicraft Industry"),
//       Category(225, "Indian Manufacturing"),
//       Category(226, "Indian Pharmaceutical Industry"),
//       Category(227, "Indian Truck Industry"),
//       Category(228, "IT Industry in India"),
//       Category(229, "Logistics Industry"),
//       Category(230, "Machinery Industry"),
//       Category(231, "Metallurgical Industry"),
//       Category(232, "Reliance Industries"),
//       Category(233, "Retail Industry In India"),
//       Category(234, "Software Industry"),
//       Category(235, "Steel Industry"),
//       Category(236, "Telecom Industry"),
//       Category(237, "Textile Industry in India"),
//       Category(238, "Wool Industry"),
//       Category(239, "Silk Industry"),
//       Category(240, "Pottery Industry"),
//       Category(241, "Banking "),
//       Category(242, "insurance"),
//       Category(243, "mutual fund"),
//       Category(244, "real estate"),
//       Category(245, "furniture "),
//       Category(246, "jute"),
//       Category(247, "leather"),
//       Category(248, "paper "),
//       Category(249, "plastic "),
//       Category(250, "rubber "),
//       Category(251, "silk"),
//       Category(252, "television"),
//       Category(253, "textile"),
//       Category(254, "garment "),
//       Category(255, "weaving"),
//       Category(256, "biscuit"),
//       Category(257, "soap"),
//       Category(258, "bio technology"),
//       Category(259, "health care"),
//       Category(260, "pharmaceutical"),
//       Category(261, "turbine"),
//       Category(262, "fashion"),
//       Category(263, "poultry"),
//       Category(264, "tourism"),
//       Category(265, "telecom"),
//       Category(266, "railway")
//     ];
//   }
// }

// class EventType {
//   int id;
//   String name;
//   EventType(this.id, this.name);
//   static List<EventType> getEventType() {
//     return <EventType>[
//       EventType(1, 'Music'),
//       EventType(2, 'Business'),
//       EventType(3, 'Professional'),
//       EventType(4, 'Food'),
//       EventType(5, 'Drink'),
//       EventType(6, 'Community'),
//       EventType(7, 'Culture'),
//       EventType(8, 'Performing'),
//       EventType(9, 'Visula Art'),
//       EventType(10, 'Film'),
//       EventType(11, 'Media'),
//       EventType(12, 'Entertainment'),
//       EventType(13, 'Sports'),
//       EventType(14, 'Fitness'),
//       EventType(15, 'Health'),
//       EventType(16, 'Wellness'),
//       EventType(17, 'Science'),
//       EventType(18, 'Technology'),
//       EventType(19, 'Travel'),
//       EventType(20, 'Outdoor'),
//       EventType(21, 'Gaming'),
//       EventType(22, 'Charity'),
//       EventType(23, 'Cause'),
//       EventType(24, 'Religion'),
//       EventType(25, 'Spirituality'),
//       EventType(26, 'Family'),
//       EventType(27, 'Education'),
//       EventType(28, 'Seasonal'),
//       EventType(29, 'Holiday'),
//     ];
//   }
// }

// class Timing {
//   int id;
//   String name;
//   Timing(this.id, this.name);
//   static List<Timing> getTiming() {
//     return <Timing>[
//       Timing(1, 'Full time'),
//       Timing(2, 'Part time'),
//       Timing(3, 'Task based'),
//       Timing(2, 'Hourly pay'),
//     ];
//   }
// }

// class Salary {
//   int id;
//   String name;
//   Salary(this.id, this.name);
//   static List<Salary> getSalary() {
//     return <Salary>[
//       Salary(1, ' Per annum'),
//       Salary(2, ' Per hour'),
//       Salary(3, ' Per task'),
//       Salary(2, ' Per contract'),
//     ];
//   }
// }

// class _JobPostState extends State<JobPost> {
//   TextEditingController jobTitleController = TextEditingController();
//   TextEditingController designationController = TextEditingController();
//   TextEditingController aboutController = TextEditingController();
//   TextEditingController websiteController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   TextEditingController salaryController = TextEditingController();
//   TextEditingController endDateController = TextEditingController();
//   TextEditingController ticketNameController = TextEditingController();
//   TextEditingController numTicketsController = TextEditingController();
//   TextEditingController saleStartController = TextEditingController();
//   TextEditingController saleEndController = TextEditingController();
//   TextEditingController ticketVisibilityController = TextEditingController();
//   TextEditingController salesChannelController = TextEditingController();
//   TextEditingController ticketPerHeadMinController = TextEditingController();
//   TextEditingController ticketPerHeadMaxController = TextEditingController();
//   List<Category> _category = Category.getCategory();
//   List<DropdownMenuItem<Category>> _dropDownMenuCategory;
//   Category _selectedCategory;
//   // List<EventType> _eventType = EventType.getEventType();
//   // List<DropdownMenuItem<EventType>> _dropDownMenuEventType;
//   //EventType _selectedEventType;
//   List<Timing> _timing = Timing.getTiming();
//   List<Salary> _salary = Salary.getSalary();
//   List<DropdownMenuItem<Timing>> _dropDownMenuTiming;
//   List<DropdownMenuItem<Salary>> _dropDownMenuSalary;
//   Timing _selectedTiming;
//   Salary _selectedSalary;
//   String selectedStatus;
//   bool isSelectedStatusLocation;
//   final format = DateFormat('yyyy-MM-dd HH:mm');
//   String selectedPrice;
//   bool isSelectedPriceFree;
//   final _repository = Repository();
//   TextEditingController _industryController = new TextEditingController();
//   GlobalKey<AutoCompleteTextFieldState<Industry>> inkey = new GlobalKey();
//   static List<Industry> industries = new List<Industry>();
//   AutoCompleteTextField industryTextField;
//   TextEditingController _locationController = new TextEditingController();
//   GlobalKey<AutoCompleteTextFieldState<Location>> lkey = new GlobalKey();
//   static List<Location> locations = new List<Location>();
//   AutoCompleteTextField locationTextField;
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     getIndustry();
//     getLocation();
//     _dropDownMenuCategory = buildDropDownMenuCategory(_category);
//     _selectedCategory = _dropDownMenuCategory[0].value;
//     //  _dropDownMenuEventType = buildDropDownMenuEventType(_eventType);
//     //_selectedEventType = _dropDownMenuEventType[0].value;
//     _dropDownMenuTiming = buildDropDownMenuTiming(_timing);
//     _selectedTiming = _dropDownMenuTiming[0].value;
//     _dropDownMenuSalary = buildDropDownMenuSalary(_salary);
//     _selectedSalary = _dropDownMenuSalary[0].value;
//     selectedStatus = "Location";
//     isSelectedStatusLocation = true;
//     selectedPrice = "Free";
//     isSelectedPriceFree = true;
//   }

//   setSelectedStatus(String val) {
//     setState(() {
//       selectedStatus = val;
//     });
//   }

//   setSelectedPrice(String val) {
//     setState(() {
//       selectedPrice = val;
//     });
//   }

//   void getLocation() async {
//     try {
//       final response =
//           await http.get(Uri.parse("https://kuldeeprawat64.github.io/data/location.json"));
//       if (response.statusCode == 200) {
//         locations = loadLocation(response.body);
//         //  print('Industry: ${industries.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //   print("Error getting Industry.");
//       }
//     } catch (e) {
//       //  print("Error getting Industry.");
//     }
//   }

//   static List<Location> loadLocation(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<Location>((json) => Location.fromJson(json)).toList();
//   }

//   Widget irow(Industry industry) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           industry.name,
//           style: TextStyle(fontSize: 14.0),
//         ),
//         SizedBox(
//           width: 10.0,
//           // height: 10.0,
//         ),
//         Divider()
//         // Text(
//         //   user.email,
//         // ),
//       ],
//     );
//   }

//   void getIndustry() async {
//     try {
//       final response =
//           await http.get(Uri.parse("https://kuldeeprawat64.github.io/data/industry.json"));
//       if (response.statusCode == 200) {
//         industries = loadIndustry(response.body);
//         //  print('Industry: ${industries.length}');
//         setState(() {
//           loading = false;
//         });
//       } else {
//         //   print("Error getting Industry.");
//       }
//     } catch (e) {
//       //  print("Error getting Industry.");
//     }
//   }

//   static List<Industry> loadIndustry(String jsonString) {
//     final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//     return parsed.map<Industry>((json) => Industry.fromJson(json)).toList();
//   }

//   Widget lrow(Location locations) {
//     return Wrap(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           locations.name,
//           style: TextStyle(fontSize: 14.0),
//         ),
//         SizedBox(
//           width: 10.0,
//           // height: 10.0,
//         ),
//         Divider()
//         // Text(
//         //   user.email,
//         // ),
//       ],
//     );
//   }

//   List<DropdownMenuItem<Category>> buildDropDownMenuCategory(List categories) {
//     List<DropdownMenuItem<Category>> items = List();
//     for (Category category in categories) {
//       items.add(
//         DropdownMenuItem(
//           value: category,
//           child: Text(category.name),
//         ),
//       );
//     }
//     return items;
//   }

//   onChangeDropDownCategory(Category selectedCategory) {
//     setState(() {
//       _selectedCategory = selectedCategory;
//     });
//   }

//   List<DropdownMenuItem<EventType>> buildDropDownMenuEventType(
//       List eventTypes) {
//     List<DropdownMenuItem<EventType>> items = List();
//     for (EventType eventType in eventTypes) {
//       items.add(
//         DropdownMenuItem(
//           value: eventType,
//           child: Text(eventType.name),
//         ),
//       );
//     }
//     return items;
//   }

//   onChangeDropDownEventType(EventType selectedEventType) {
//     setState(() {
//       // _selectedEventType = selectedEventType;
//     });
//   }

//   List<DropdownMenuItem<Timing>> buildDropDownMenuTiming(List timings) {
//     List<DropdownMenuItem<Timing>> items = List();
//     for (Timing timing in timings) {
//       items.add(
//         DropdownMenuItem(
//           value: timing,
//           child: Text(timing.name),
//         ),
//       );
//     }
//     return items;
//   }

//   onChangeDropDownTiming(Timing selectedTiming) {
//     setState(() {
//       _selectedTiming = selectedTiming;
//     });
//   }

//   List<DropdownMenuItem<Salary>> buildDropDownMenuSalary(List salaries) {
//     List<DropdownMenuItem<Salary>> items = List();
//     for (Salary salary in salaries) {
//       items.add(
//         DropdownMenuItem(
//           value: salary,
//           child: Text(salary.name),
//         ),
//       );
//     }
//     return items;
//   }

//   onChangeDropDownSalary(Salary selectedSalary) {
//     setState(() {
//       _selectedSalary = selectedSalary;
//     });
//   }

//   bool _visibility = true;

//   void _changeVisibility(bool visibility) {
//     setState(() {
//       _visibility = visibility;
//     });
//   }

//   submit() {
//     if (jobTitleController.text.isNotEmpty &&
//         _locationController.text.isNotEmpty &&
//         salaryController.text.isNotEmpty &&
//         aboutController.text.isNotEmpty) {
//       //To show CircularProgressIndicator
//       _changeVisibility(false);

//       _repository.getCurrentUser().then((currentUser) {
//         if (currentUser != null) {
//           _repository.retreiveUserDetails(currentUser).then((user) {
//             _repository
//                 .addJobToDb(
//                     user,
//                     jobTitleController.text,
//                     _locationController.text,
//                     _industryController.text,
//                     aboutController.text,
//                     websiteController.text)
//                 .then((value) {
//               print('Job added to db');
//               Navigator.pushReplacement(
//                   context, MaterialPageRoute(builder: (context) => Home()));
//             }).catchError((e) => print('Error adding current job to db : $e'));
//           }).catchError((e) {
//             print('Error uploading image to storage : $e');
//           });
//         } else {
//           print('Current User is null');
//         }
//       });
//     } else {
//       return;
//     }
//   }

//   @override
//   void dispose() {
//     jobTitleController?.dispose();
//     _locationController?.dispose();
//     salaryController?.dispose();
//     aboutController?.dispose();
//     websiteController?.dispose();
//     _industryController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color(0xfff6f6f6),
//         appBar: AppBar(
//           elevation: 0.5,
//           leading: IconButton(
//               icon: Icon(Icons.keyboard_arrow_left,
//                   size: screenSize.height * 0.045, color: Colors.black54),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               }),
//           title: Text(
//             'Post a Job',
//             style: TextStyle(
//               fontFamily: FontNameDefault,
//               fontSize: textAppTitle(context),
//               color: Colors.black54,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: const Color(0xffffffff),
//           //  centerTitle: true,
//           actions: [
//             _visibility
//                 ? Padding(
//                     padding: EdgeInsets.only(right: screenSize.width / 30),
//                     child: GestureDetector(
//                       child: Icon(
//                         Icons.send,
//                         size: screenSize.height * 0.035,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       onTap: submit,
//                     ),
//                   )
//                 : Container(),
//           ],
//         ),
//         body: ListView(
//           padding: EdgeInsets.fromLTRB(
//             screenSize.width / 11,
//             screenSize.height * 0.01,
//             screenSize.width / 11,
//             0,
//           ),
//           children: <Widget>[
//             !_visibility ? linearProgress() : Text(""),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Job title',
//                   style: TextStyle(
//                     fontFamily: FontNameDefault,
//                     fontSize: textSubTitle(context),
//                     color: Colors.black54,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Container(
//                   height: screenSize.height * 0.09,
//                   child: TextFormField(
//                     autocorrect: true,
//                     textCapitalization: TextCapitalization.sentences,
//                     style: TextStyle(
//                         fontFamily: FontNameDefault,
//                         fontSize: textBody1(context)),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xffffffff),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0)),
//                       hintText: 'Title of a job',
//                     ),
//                     controller: jobTitleController,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                   child: Text(
//                     'Location',
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textSubTitle(context),
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 loading
//                     ? CircularProgressIndicator()
//                     : Padding(
//                         padding:
//                             EdgeInsets.only(top: screenSize.height * 0.012),
//                         child: Container(
//                           height: screenSize.height * 0.09,
//                           child: locationTextField =
//                               AutoCompleteTextField<Location>(
//                             controller: _locationController,
//                             key: lkey,
//                             clearOnSubmit: false,
//                             suggestions: locations,
//                             style: TextStyle(
//                               fontFamily: FontNameDefault,
//                               color: Colors.black,
//                               fontSize: textBody1(context),
//                             ),
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: const Color(0xffffffff),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               hintText: "Enter the location e.g. Mumbai",
//                               //  labelText: 'Location',
//                             ),
//                             itemFilter: (item, query) {
//                               return item.name
//                                   .toLowerCase()
//                                   .startsWith(query.toLowerCase());
//                             },
//                             itemSorter: (a, b) {
//                               return a.name.compareTo(b.name);
//                             },
//                             itemSubmitted: (item) {
//                               setState(() {
//                                 locationTextField.textField.controller.text =
//                                     item.name;
//                               });
//                             },
//                             itemBuilder: (context, item) {
//                               // ui for the autocompelete row
//                               return lrow(item);
//                             },
//                           ),
//                         ),
//                       ),
//                 Padding(
//                   padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                   child: Text(
//                     'Description',
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textSubTitle(context),
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     // style: TextStyle(),
//                   ),
//                 ),
//                 Container(
//                   height: screenSize.height * 0.2,
//                   child: TextFormField(
//                     autocorrect: true,
//                     textCapitalization: TextCapitalization.sentences,
//                     style: TextStyle(
//                         fontFamily: FontNameDefault,
//                         fontSize: textBody1(context)),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xffffffff),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0)),
//                       hintText: 'Detail info about job and requirements',
//                     ),
//                     keyboardType: TextInputType.multiline,
//                     minLines: 5,
//                     maxLines: 5,
//                     controller: aboutController,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                   child: Text(
//                     'Industry',
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textSubTitle(context),
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 loading
//                     ? CircularProgressIndicator()
//                     : Padding(
//                         padding:
//                             EdgeInsets.only(top: screenSize.height * 0.012),
//                         child: Container(
//                           height: screenSize.height * 0.09,
//                           child: industryTextField =
//                               AutoCompleteTextField<Industry>(
//                             controller: _industryController,
//                             key: inkey,
//                             clearOnSubmit: false,
//                             suggestions: industries,
//                             style: TextStyle(
//                               fontFamily: FontNameDefault,
//                               color: Colors.black,
//                               fontSize: textBody1(context),
//                             ),
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: const Color(0xffffffff),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               hintText: "Enter your field e.g. Finance",
//                               //labelText: 'Industry',
//                             ),
//                             itemFilter: (item, query) {
//                               return item.name
//                                   .toLowerCase()
//                                   .startsWith(query.toLowerCase());
//                             },
//                             itemSorter: (a, b) {
//                               return a.name.compareTo(b.name);
//                             },
//                             itemSubmitted: (item) {
//                               setState(() {
//                                 industryTextField.textField.controller.text =
//                                     item.name;
//                               });
//                             },
//                             itemBuilder: (context, item) {
//                               // ui for the autocompelete row
//                               return irow(item);
//                             },
//                           ),
//                         ),
//                       ),
//                 Padding(
//                   padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                   child: Text(
//                     'Timing',
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textSubTitle(context),
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0)),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                     child: DropdownButton(
//                       underline: Container(color: Colors.white),
//                       style: TextStyle(
//                         fontFamily: FontNameDefault,
//                         fontSize: textBody1(context),
//                         color: Colors.black87,
//                       ),
//                       icon: Icon(Icons.keyboard_arrow_down,
//                           color: Theme.of(context).primaryColor),
//                       iconSize: screenSize.height * 0.06,
//                       isExpanded: true,
//                       value: _selectedTiming,
//                       items: _dropDownMenuTiming,
//                       onChanged: onChangeDropDownTiming,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                   child: Text(
//                     'Salary',
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textSubTitle(context),
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   //  mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: screenSize.height * 0.07,
//                       width: screenSize.width / 2.5,
//                       child: TextFormField(
//                         style: TextStyle(
//                             fontFamily: FontNameDefault,
//                             fontSize: textBody1(context)),
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             filled: true,
//                             fillColor: const Color(0xffffffff),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             hintText: 'eg. 1,00,000'),
//                         controller: salaryController,
//                       ),
//                     ),
//                     Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20.0)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                         child: DropdownButton(
//                             underline: Container(color: Colors.white),
//                             style: TextStyle(
//                               fontFamily: FontNameDefault,
//                               fontSize: textBody1(context),
//                               color: Colors.black87,
//                             ),
//                             icon: Icon(Icons.keyboard_arrow_down,
//                                 color: Theme.of(context).primaryColor),
//                             iconSize: screenSize.height * 0.06,
//                             value: _selectedSalary,
//                             items: _dropDownMenuSalary,
//                             onChanged: onChangeDropDownSalary),
//                       ),
//                     )
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: screenSize.height * 0.012),
//                   child: Text(
//                     'Company website',
//                     style: TextStyle(
//                       fontFamily: FontNameDefault,
//                       fontSize: textSubTitle(context),
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: screenSize.height * 0.09,
//                   child: TextFormField(
//                     style: TextStyle(
//                         fontFamily: FontNameDefault,
//                         fontSize: textBody1(context)),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xffffffff),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       hintText: 'https://www.companyaddress.com',
//                     ),
//                     controller: websiteController,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   getUserLocation() async {
//     Position position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     List<Placemark> placemarks = await Geolocator()
//         .placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark placemark = placemarks[0];
//     String completeAddress =
//         '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
//     print(completeAddress);
//     String formattedAddress = "${placemark.locality}, ${placemark.country}";
//     _locationController.text = formattedAddress;
//   }
// }
