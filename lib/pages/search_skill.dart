//import 'package:Yujai/pages/login_page.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import '../models/user.dart';
import 'home.dart';
//import 'professional_purpose.dart';

class SearchSkill extends StatefulWidget {
  @override
  _SearchSkillState createState() => _SearchSkillState();
}

class _SearchSkillState extends State<SearchSkill>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _key;
  List<Interest> _interests;
  List<String> _filters;
  bool isLoading = false;
  bool isSelected = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
    _filters = <String>[];
    _interests = <Interest>[
      const Interest("A"),
      const Interest("A + Certified"),
      const Interest("A-110"),
      const Interest("A-122"),
      const Interest("A-123"),
      const Interest("A-133"),
      const Interest("A-frames"),
      const Interest("A-GPS"),
      const Interest("A/B Testing"),
      const Interest("A/R analysis"),
      const Interest("A/R Collections"),
      const Interest("A/R Management"),
      const Interest("A/V design"),
      const Interest("A/V editing"),
      const Interest("A/V Engineering"),
      const Interest("A/V systems"),
      const Interest("A&D"),
      const Interest("A&E"),
      const Interest("A&H"),
      const Interest("A&P"),
      const Interest("A&R"),
      const Interest("A&R Administration"),
      const Interest("A&U"),
      const Interest("A+"),
      const Interest("A+ Certified"),
      const Interest("A+ Certified IT Technician"),
      const Interest("A+ Certified Professional"),
      const Interest("A+ Essentials"),
      const Interest("A+ Trained"),
      const Interest("Budgeting "),
      const Interest("Business Planning"),
      const Interest("Business Re-engineering"),
      const Interest("Change Management"),
      const Interest("Consolidation"),
      const Interest("Cost Control"),
      const Interest("Decision Making"),
      const Interest("Developing Policies "),
      const Interest("Diversification"),
      const Interest("Employee Evaluation"),
      const Interest("Financing"),
      const Interest("Government Relations"),
      const Interest("Hiring"),
      const Interest("International Management"),
      const Interest("Investor Relations"),
      const Interest("IPO "),
      const Interest("Joint Ventures"),
      const Interest("Labour Relations"),
      const Interest("Merger & Acquisitions"),
      const Interest("Multi-sites Management"),
      const Interest("Negotiation"),
      const Interest("Profit & Loss "),
      const Interest("Organizational Development"),
      const Interest("Project Management"),
      const Interest("Staff Development"),
      const Interest("Strategic Partnership"),
      const Interest("Strategic Planning"),
      const Interest("Supervision"),
      const Interest("Bidding "),
      const Interest("Call Centre Operations "),
      const Interest("Continuous Improvement "),
      const Interest("Contract Management "),
      const Interest("Environmental Protection "),
      const Interest("Facility Management"),
      const Interest("Inventory Control  "),
      const Interest("Manpower Planning  "),
      const Interest("Operations Research"),
      const Interest("Outsourcing "),
      const Interest("Policies & Procedures"),
      const Interest("Project Co-ordination"),
      const Interest("Project Management"),
      const Interest("Equipment Design "),
      const Interest("Equipment Maintenance & Repair"),
      const Interest("Equipment Management    "),
      const Interest("ISO   "),
      const Interest("TQM "),
      const Interest("Order Processing   "),
      const Interest("Plant Design & Layout   "),
      const Interest("Process Engineering"),
      const Interest("Production Planning  "),
      const Interest("Quality Assurance  "),
      const Interest("Safety Engineerin"),
      const Interest("Distribution "),
      const Interest("Transportation "),
      const Interest("JIT"),
      const Interest("Purchasing & Procurement "),
      const Interest("Shipping  "),
      const Interest("Traffic Management"),
      const Interest("Warehousing "),
      const Interest("Design & Specification "),
      const Interest("Diagnostics "),
      const Interest("Feasibility Studies"),
      const Interest("Field Studies"),
      const Interest("Lab Management  "),
      const Interest("Lab Design "),
      const Interest("Equipment Design "),
      const Interest("Patent Application "),
      const Interest("Product Development "),
      const Interest("Product Testing  "),
      const Interest("Prototype Development "),
      const Interest("R&D Management "),
      const Interest("Simulation Dev.       "),
      const Interest("Statistical Analysis "),
      const Interest("Technical Writing"),
      const Interest("Account Management "),
      const Interest("B2B  "),
      const Interest("Contract Negotiation "),
      const Interest("Customer Relations "),
      const Interest("Customer Service   "),
      const Interest("Direct Sales"),
      const Interest("Distributor Relations "),
      const Interest("E-Commerce    "),
      const Interest("Forecasting"),
      const Interest("Incentive Programs "),
      const Interest("International Business Development"),
      const Interest("International Expansion"),
      const Interest("New Account Development  "),
      const Interest("Proposal Writing"),
      const Interest("Product Demonstrations  "),
      const Interest("Telemarketing  "),
      const Interest("Trade Shows "),
      const Interest("Sales Administration "),
      const Interest("Sales Analysis  "),
      const Interest("Sales Kits "),
      const Interest("Sales Management "),
      const Interest("Salespersons Recruitment  "),
      const Interest("Show Room Management"),
      const Interest("Sales Support  "),
      const Interest("Sales Training"),
      const Interest("Advertising  "),
      const Interest("Brand Management  "),
      const Interest("Channel Marketing"),
      const Interest("Competitive Analysis "),
      const Interest("Copywriting   "),
      const Interest("Corporate Identity"),
      const Interest("Image Development   "),
      const Interest("Logo Development  "),
      const Interest("Market Research & Analysis"),
      const Interest("Marketing Communication "),
      const Interest("Marketing Plan   "),
      const Interest("Marketing promotions"),
      const Interest("Media Buying/Evaluation "),
      const Interest("Media Relations  "),
      const Interest("Merchandising "),
      const Interest("Product Development "),
      const Interest("Online Marketing "),
      const Interest("Packaging "),
      const Interest("Pricing "),
      const Interest("Product Launch "),
      const Interest("Contract Negotiation  "),
      const Interest("Equipment Purchasing "),
      const Interest("Forms and Methods"),
      const Interest("Leases "),
      const Interest("Mailroom Management "),
      const Interest("Office Management"),
      const Interest("Policies & Procedures "),
      const Interest("Reception   "),
      const Interest("Records Management"),
      const Interest("Security  "),
      const Interest("Space Planning  "),
      const Interest("Word Processing"),
      const Interest("Contract Preparation "),
      const Interest("Copyrights & Trademarks  "),
      const Interest("Corporate Law "),
      const Interest("Company Secretary  "),
      const Interest("Employment Ordinance    "),
      const Interest("Intellectual Property "),
      const Interest("International Agreements  "),
      const Interest("Licensing"),
      const Interest("Mergers & Acquisitions "),
      const Interest("Patents   "),
      const Interest("Shareholder proxies"),
      const Interest("Stock Administration"),
      const Interest("Accounting Management "),
      const Interest("Accounts Payable  "),
      const Interest("Venture Capital Relations"),
      const Interest("Accounts Receivable  "),
      const Interest("Acquisitions & Mergers  "),
      const Interest("Actuarial/Rating Analysis"),
      const Interest("Auditing   "),
      const Interest("Banking Relations  "),
      const Interest("Budget Control "),
      const Interest("Capital Budgeting "),
      const Interest("Capital Investment  "),
      const Interest("Cash Management "),
      const Interest("Cost Accounting "),
      const Interest("Cost Control  "),
      const Interest("Credit/Collections "),
      const Interest("Debt Negotiations "),
      const Interest("Equity/Debt Management "),
      const Interest("Feasibility Studies"),
      const Interest("Financial Analysis "),
      const Interest("Financial Reporting "),
      const Interest("Financing "),
      const Interest("Forecasting "),
      const Interest("Foreign Exchange "),
      const Interest("General Ledger"),
      const Interest("Insurance  "),
      const Interest("Internal Controls "),
      const Interest("Investor Relations  "),
      const Interest("Lending "),
      const Interest("Lines of Credit"),
      const Interest("Management Reporting"),
      const Interest("Payroll  "),
      const Interest("Fund Management"),
      const Interest("Profit Planning  "),
      const Interest("Risk Management"),
      const Interest("Stockholder Relations"),
      const Interest("Tax    "),
      const Interest("Treasury    "),
      const Interest("Investor Presentation"),
      const Interest("Arbitration/Mediation "),
      const Interest("Career Counseling  "),
      const Interest("Career Coaching "),
      const Interest("Classified Advertisements "),
      const Interest("Company Orientation   "),
      const Interest("Workforce Forecast/Planning "),
      const Interest("Compensation & Benefits "),
      const Interest("Corporate Culture "),
      const Interest("Training Administration "),
      const Interest("Employee Discipline "),
      const Interest("Employee Selection "),
      const Interest("Executive Recruiting "),
      const Interest("Grievance Resolution  "),
      const Interest("Human Resources Management "),
      const Interest("Industrial Relations   "),
      const Interest("Job Analysis  "),
      const Interest("Labour Negotiations"),
      const Interest("Outplacement  "),
      const Interest("Performance Appraisal "),
      const Interest("Salary Administration"),
      const Interest("Succession Planning "),
      const Interest("Team Building   "),
      const Interest("Training"),
      const Interest("Algorithm Development "),
      const Interest("Application Database Administration"),
      const Interest("Applications Development "),
      const Interest("Business Systems Planning "),
      const Interest("Web Site Editor"),
      const Interest("Capacity Planning "),
      const Interest("CRM    "),
      const Interest("CAD "),
      const Interest("EDI  "),
      const Interest("Enterprise Asset Management "),
      const Interest("EAP "),
      const Interest("Enterprise Resource Planning ERP   "),
      const Interest("Hardware Management"),
      const Interest("Information Management  "),
      const Interest("Integration Software   "),
      const Interest("Intranet"),
      const Interest("Development Languages – JAVA, C+++, etc    "),
      const Interest("Portal Design/Development"),
      const Interest("Software Customization  "),
      const Interest("Software Development   "),
      const Interest("System Analysis "),
      const Interest("System Design   "),
      const Interest("System Development   "),
      const Interest("Technical Evangelism"),
      const Interest("Technical Support  "),
      const Interest("Technical Writing "),
      const Interest("Telecommunications "),
      const Interest("Tracking System  "),
      const Interest("UNIX  "),
      const Interest("Usability Engineering"),
      const Interest("User Education  "),
      const Interest("User Documentation    "),
      const Interest("User Interface"),
      const Interest("Vendor Sourcing  "),
      const Interest("Voice & Data Communications "),
      const Interest("Web Development/Design"),
      const Interest("Web Site Content Writer  "),
      const Interest("Word Processing"),
      const Interest("Character Development"),
      const Interest("Creative Writing "),
      const Interest("Drawing"),
      const Interest("Musical Composition "),
      const Interest("Story Line Development "),
      const Interest("Visual Composition"),
      const Interest("Colour Theory "),
      const Interest("Dreamweaver  "),
      const Interest("Flash "),
      const Interest("Freehand  "),
      const Interest("Illustrator   "),
      const Interest("Photoshop"),
      const Interest("Picasa  "),
      const Interest("Corel Draw  "),
      const Interest("Typography "),
      const Interest("Print Design & Layout "),
      const Interest("Photography"),
      const Interest("B2B Communication "),
      const Interest("Community Relations "),
      const Interest("Speech Writing "),
      const Interest("Corporate Image "),
      const Interest("Corporate Philanthropy  "),
      const Interest("Corporate Publications"),
      const Interest("Corporate Relations  "),
      const Interest("Employee Communication "),
      const Interest("Event Planning "),
      const Interest("Fund Raising  "),
      const Interest("Government Relations"),
      const Interest("Investor Collateral"),
      const Interest("Media Presentations "),
      const Interest("Press Release  "),
      const Interest("Risk Mgt Communication ")
    ];
  }

  submit() async {
    FirebaseUser currentUser = await _auth.currentUser();
    usersRef.document(currentUser.uid).updateData({
      "skills": _filters,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffffffff),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: screenSize.height * 0.045,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.5,
          title: Text(
            'Skills',
            style: TextStyle(
                fontFamily: FontNameDefault,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: textAppTitle(context)),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width / 50,
              ),
              child: GestureDetector(
                onTap: submit,
                child: Container(
                  height: screenSize.height * 0.055,
                  width: screenSize.width * 0.15,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      color: Colors.white,
                      fontSize: textButton(context),
                    ),
                  )),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xfff6f6f6),
        key: _key,
        body: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.only(top: screenSize.height * 0.01),
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenSize.height * 0.01,
                    ),
                    child: Text(
                      '* You can choose any 5 options from below',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: interestWidgets.toList(),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Iterable<Widget> get interestWidgets sync* {
    var screenSize = MediaQuery.of(context).size;
    for (Interest interest in _interests) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Colors.grey[200],
          elevation: 0.0,
          selectedColor: Colors.grey[400],
          avatar: CircleAvatar(
            child: Text(interest.name[0].toUpperCase()),
          ),
          label: Text(interest.name),
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textBody1(context),
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          selected: _filters.contains(interest.name),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(interest.name);
                isSelected = selected;
              } else {
                _filters.removeWhere((String name) {
                  return name == interest.name;
                });
                isSelected = false;
              }
            });
          },
        ),
      );
    }
  }

  Widget chip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(5.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 12.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(6.0),
    );
  }
}

class Interest {
  const Interest(this.name);
  final String name;
}
