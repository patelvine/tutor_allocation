# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

Users = [
  User.create({
    email: "TutorManager@ecs.ecs",
    username: "TutorManager",
    password: "123456789",
    role: "TM"
  }),



  User.create({
    id: 1001,
    email: "NicoleMathis@ecs.ecs",
    username: "NicoleMathis",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1002,
    email: "DeannaColeman@ecs.ecs",
    username: "DeannaColeman",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1003,
    email: "BobbieJackson@ecs.ecs",
    username: "BobbieJackson",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1004,
    email: "KarlaAustin@ecs.ecs",
    username: "KarlaAustin",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1005,
    email: "AbrahamGrant@ecs.ecs",
    username: "AbrahamGrant",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1006,
    email: "PatTodd@ecs.ecs",
    username: "PatTodd",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1007,
    email: "AlexBecker@ecs.ecs",
    username: "AlexBecker",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1008,
    email: "CedricRose@ecs.ecs",
    username: "CedricRose",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1009,
    email: "MinnieWalker@ecs.ecs",
    username: "MinnieWalker",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1010,
    email: "FernandoHall@ecs.ecs",
    username: "FernandoHall",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1011,
    email: "KellyRamirez@ecs.ecs",
    username: "KellyRamirez",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1012,
    email: "JeanetteSparks@ecs.ecs",
    username: "JeanetteSparks",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1013,
    email: "DonStephens@ecs.ecs",
    username: "DonStephens",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1014,
    email: "MarshallEvans@ecs.ecs",
    username: "MarshallEvans",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1015,
    email: "MarianArmstrong@ecs.ecs",
    username: "MarianArmstrong",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1016,
    email: "StevenJohnston@ecs.ecs",
    username: "StevenJohnston",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1017,
    email: "SadieNewton@ecs.ecs",
    username: "SadieNewton",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1018,
    email: "LoisTyler@ecs.ecs",
    username: "LoisTyler",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1019,
    email: "KristaOrtega@ecs.ecs",
    username: "KristaOrtega",
    password: "123456789",
    role: "CC"
  }),
  User.create({
    id: 1020,
    email: "AdaButler@ecs.ecs",
    username: "AdaButler",
    password: "123456789",
    role: "CC"
  }),



  User.create({
    email: "GregHunt@ecs.ecs",
    username: "GregHunt",
    password: "123456789",
    role: "student",
    student_ID: "100001"
  }),
  User.create({
    email: "ClintonBarrett@ecs.ecs",
    username: "ClintonBarrett",
    password: "123456789",
    role: "student",
    student_ID: "100002"
  }),
  User.create({
    email: "EuniceWilkins@ecs.ecs",
    username: "EuniceWilkins",
    password: "123456789",
    role: "student",
    student_ID: "100003"
  }),
  User.create({
    email: "JaimBlake@ecs.ecs",
    username: "JaimeBlake",
    password: "123456789",
    role: "student",
    student_ID: "100004"
  }),
  User.create({
    email: "SallyAllen@ecs.ecs",
    username: "SallyAllen",
    password: "123456789",
    role: "student",
    student_ID: "100005"
  }),
  User.create({
    email: "JoeyWilson@ecs.ecs",
    username: "JoeyWilson",
    password: "123456789",
    role: "student",
    student_ID: "100006"
  }),
  User.create({
    email: "JanReeves@ecs.ecs",
    username: "JanReeves",
    password: "123456789",
    role: "student",
    student_ID: "100007"
  }),
  User.create({
    email: "ConstanceVaughn@ecs.ecs",
    username: "ConstanceVaughn",
    password: "123456789",
    role: "student",
    student_ID: "100008"
  }),
  User.create({
    email: "JoshMendoza@ecs.ecs",
    username: "JoshMendoza",
    password: "123456789",
    role: "student",
    student_ID: "100009"
  }),
  User.create({
    email: "AntoniaFloyd@ecs.ecs",
    username: "AntoniaFloyd",
    password: "123456789",
    role: "student",
    student_ID: "100010"
  }),
  User.create({
    email: "LorettaGlover@ecs.ecs",
    username: "JLorettaGlover",
    password: "123456789",
    role: "student",
    student_ID: "100011"
  }),
  User.create({
    email: "JanisHogan@ecs.ecs",
    username: "JanisHogan",
    password: "123456789",
    role: "student",
    student_ID: "100012"
  }),
  User.create({
    email: "DexterParks@ecs.ecs",
    username: "DexterParks",
    password: "123456789",
    role: "student",
    student_ID: "100013"
  }),
  User.create({
    email: "IraAlvarado@ecs.ecs",
    username: "IraAlvarado",
    password: "123456789",
    role: "student",
    student_ID: "100014"
  }),
  User.create({
    email: "JoycePoole@ecs.ecs",
    username: "JoycePoole",
    password: "123456789",
    role: "student",
    student_ID: "100015"
  }),
  User.create({
    email: "PaulineDavis@ecs.ecs",
    username: "PaulineDavis",
    password: "123456789",
    role: "student",
    student_ID: "100016"
  }),
  User.create({
    email: "MartaSnyder@ecs.ecs",
    username: "MartaSnyder",
    password: "123456789",
    role: "student",
    student_ID: "100017"
  }),
  User.create({
    email: "JanetWallace@ecs.ecs",
    username: "JanetWallace",
    password: "123456789",
    role: "student",
    student_ID: "100018"
  }),
  User.create({
    email: "GayleFleming@ecs.ecs",
    username: "GayleFleming",
    password: "123456789",
    role: "student",
    student_ID: "100019"
  }),
  User.create({
    email: "GerardoCooper@ecs.ecs",
    username: "GerardoCooper",
    password: "123456789",
    role: "student",
    student_ID: "100020"
  }),
  User.create({
    email: "EvanWise@ecs.ecs",
    username: "EvanWise",
    password: "123456789",
    role: "student",
    student_ID: "100021"
  }),
  User.create({
    email: "GwenLopez@ecs.ecs",
    username: "GwenLopez",
    password: "123456789",
    role: "student",
    student_ID: "100022"
  }),
  User.create({
    email: "MichellePowell@ecs.ecs",
    username: "MichellePowell",
    password: "123456789",
    role: "student",
    student_ID: "100023"
  }),
  User.create({
    email: "PearlWatkins@ecs.ecs",
    username: "PearlWatkins",
    password: "123456789",
    role: "student",
    student_ID: "100024"
  }),
  User.create({
    email: "SergioLawrence@ecs.ecs",
    username: "SergioLawrence",
    password: "123456789",
    role: "student",
    student_ID: "100025"
  }),
  User.create({
    email: "CaseyCaldwell@ecs.ecs",
    username: "CaseyCaldwell",
    password: "123456789",
    role: "student",
    student_ID: "100026"
  }),
  User.create({
    email: "GailNash@ecs.ecs",
    username: "GailNash",
    password: "123456789",
    role: "student",
    student_ID: "100027"
  }),
  User.create({
    email: "JoanHayes@ecs.ecs",
    username: "JoanHayes",
    password: "123456789",
    role: "student",
    student_ID: "100028"
  }),
  User.create({
    email: "TeriThompson@ecs.ecs",
    username: "TeriThompson",
    password: "123456789",
    role: "student",
    student_ID: "100029"
  }),
  User.create({
    email: "WilbertLloyd@ecs.ecs",
    username: "WilbertLloyd",
    password: "123456789",
    role: "student",
    student_ID: "100030"
  }),
  User.create({
    email: "JuanGrant@ecs.ecs",
    username: "JuanGrant",
    password: "123456789",
    role: "student",
    student_ID: "100031"
  }),
  User.create({
    email: "BarryGardner@ecs.ecs",
    username: "BarryGardner",
    password: "123456789",
    role: "student",
    student_ID: "100032"
  }),
  User.create({
    email: "OrvillePrice@ecs.ecs",
    username: "OrvillePrice",
    password: "123456789",
    role: "student",
    student_ID: "100033"
  }),
  User.create({
    email: "JimmyWalters@ecs.ecs",
    username: "JimmyWalters",
    password: "123456789",
    role: "student",
    student_ID: "100034"
  }),
  User.create({
    email: "TerriHernandez@ecs.ecs",
    username: "TerriHernandez",
    password: "123456789",
    role: "student",
    student_ID: "100035"
  }),
  User.create({
    email: "IanHarvey@ecs.ecs",
    username: "IanHarvey",
    password: "123456789",
    role: "student",
    student_ID: "100036"
  }),
  User.create({
    email: "LydiaGriffin@ecs.ecs",
    username: "LydiaGriffin",
    password: "123456789",
    role: "student",
    student_ID: "100037"
  }),
  User.create({
    email: "BlancheBarber@ecs.ecs",
    username: "BlancheBarber",
    password: "123456789",
    role: "student",
    student_ID: "100038"
  }),
  User.create({
    email: "SallyAllison@ecs.ecs",
    username: "SallyAllison",
    password: "123456789",
    role: "student",
    student_ID: "100039"
  }),
  User.create({
    email: "MeghanCampbell@ecs.ecs",
    username: "MeghanCampbell",
    password: "123456789",
    role: "student",
    student_ID: "100040"
  })
],



courses = [
  Course.create({
    name: "Introduction to Computer Graphics",
    course_code: "COMP151",
    enrollment_number: 80,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1001
  }),
  Course.create({
    name: "Introduction to Computer Program Design",
    course_code: "COMP102",
    enrollment_number: 70,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1002
  }),
  Course.create({
    name: "Introduction to Data Structures and Algorithms",
    course_code: "COMP103",
    enrollment_number: 40,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1003
  }),
  Course.create({
    name: "Introduction to Computer Science",
    course_code: "COMP112",
    enrollment_number: 60,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1004
  }),
  Course.create({
    name: "Engineering Modelling and Design",
    course_code: "ENGR110",
    enrollment_number: 60,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1005
  }),
  Course.create({
    name: "Programming for Software Development",
    course_code: "SWEN131",
    enrollment_number: 40,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1006
  }),
  Course.create({
    name: "Algorithms and Data Structures",
    course_code: "COMP261",
    enrollment_number: 34,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1007
  }),
  Course.create({
    name: "Systems Programming",
    course_code: "NWEN241",
    enrollment_number: 65,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1008
  }),
  Course.create({
    name: "Computer Organisation",
    course_code: "NWEN242",
    enrollment_number: 55,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1009
  }),
  Course.create({
    name: "Network Applications",
    course_code: "NWEN243",
    enrollment_number: 40,
    tutors_required: 4,
    state: :dormant,
    course_coordinator_id: 1010
  }),
  Course.create({
    name: "Introduction to Logic",
    course_code: "PHIL211",
    enrollment_number: 30,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1011
  }),
  Course.create({
    name: "Mind and Cognition",
    course_code: "PHIL265",
    enrollment_number: 20,
    tutors_required: 2,
    state: :dormant,
    course_coordinator_id: 1012
  }),
  Course.create({
    name: "Software Development",
    course_code: "SWEN221",
    enrollment_number: 30,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1013
  }),
  Course.create({
    name: "Software Design",
    course_code: "SWEN222",
    enrollment_number: 40,
    tutors_required: 4,
    state: :dormant,
    course_coordinator_id: 1014
  }),
  Course.create({
    name: "Software Engineering Analysis",
    course_code: "SWEN223",
    enrollment_number: 30,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1015
  }),
  Course.create({
    name: "Software Correctness",
    course_code: "SWEN224",
    enrollment_number: 60,
    tutors_required: 6,
    state: :dormant,
    course_coordinator_id: 1016
  }),
  Course.create({
    name: "Programming Languages",
    course_code: "COMP304",
    enrollment_number: 60,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1017
  }),
  Course.create({
    name: "Introduction to Artificial Intelligence",
    course_code: "COMP307",
    enrollment_number: 50,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1018
  }),
  Course.create({
    name: "Introduction to Computer Graphics",
    course_code: "COMP308",
    enrollment_number: 40,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1019
  }),
  Course.create({
    name: "Simulation and Stochastic Models",
    course_code: "COMP312",
    enrollment_number: 60,
    tutors_required: 6,
    state: :dormant,
    course_coordinator_id: 1020
  }),
  Course.create({
    name: "Computer Game Development",
    course_code: "COMP313",
    enrollment_number: 50,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1019
  }),
  Course.create({
    name: "Design and Analysis of Algorithms",
    course_code: "COMP361",
    enrollment_number: 40,
    tutors_required: 4,
    state: :dormant,
    course_coordinator_id: 1003
  }),
  Course.create({
    name: "Operating Systems Design",
    course_code: "NWEN301",
    enrollment_number: 30,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1003
  }),
  Course.create({
    name: "Computer Network Design",
    course_code: "NWEN302",
    enrollment_number: 40,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1004
  }),
  Course.create({
    name: "Advanced Network Applications",
    course_code: "NWEN304",
    enrollment_number: 90,
    tutors_required: 6,
    state: :dormant,
    course_coordinator_id: 1017
  }),
  Course.create({
    name: "Logic",
    course_code: "PHIL335",
    enrollment_number: 3,
    tutors_required: 2,
    state: :dormant,
    course_coordinator_id: 1002
  }),
  Course.create({
    name: "Structured Methods",
    course_code: "SWEN301",
    enrollment_number: 30,
    tutors_required: 4,
    state: :dormant,
    course_coordinator_id: 1018
  }),
  Course.create({
    name: "Agile Methods",
    course_code: "SWEN302",
    enrollment_number: 40,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1017
  }),
  Course.create({
    name: "User Interface Design",
    course_code: "SWEN303",
    enrollment_number: 35,
    tutors_required: 2,
    state: :dormant,
    course_coordinator_id: 1016
  }),
  Course.create({
    name: "Database System Engineering",
    course_code: "SWEN304",
    enrollment_number: 15,
    tutors_required: 1,
    state: :dormant,
    course_coordinator_id: 1019
  }),
  Course.create({
    name: "Project in Computer Graphics Programming",
    course_code: "CGRA402",
    enrollment_number: 10,
    tutors_required: 1,
    state: :dormant,
    course_coordinator_id: 1018
  }),
  Course.create({
    name: "Computer Graphics Rendering",
    course_code: "CGRA408",
    enrollment_number: 20,
    tutors_required: 2,
    state: :dormant,
    course_coordinator_id: 1006
  }),
  Course.create({
    name: "ThreeDimensional Modelling for Computer Graphics",
    course_code: "CGRA409",
    enrollment_number: 30,
    tutors_required: 2,
    state: :dormant,
    course_coordinator_id: 1007
  }),
  Course.create({
    name: "Directed Individual Study",
    course_code: "CGRA440",
    enrollment_number: 90,
    tutors_required: 8,
    state: :dormant,
    course_coordinator_id: 1007
  }),
  Course.create({
    name: "Computer Graphics Practicum",
    course_code: "CGRA463",
    enrollment_number: 90,
    tutors_required: 8,
    state: :dormant,
    course_coordinator_id: 1002
  }),
  Course.create({
    name: "Special Topic",
    course_code: "CGRA471",
    enrollment_number: 80,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1001
  }),
  Course.create({
    name: "Special Topic",
    course_code: "CGRA472",
    enrollment_number: 50,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1015
  }),
  Course.create({
    name: "Computer Graphics Project",
    course_code: "CGRA489",
    enrollment_number: 60,
    tutors_required: 4,
    state: :dormant,
    course_coordinator_id: 1011
  }),
  Course.create({
    name: "Machine Learning",
    course_code: "COMP421",
    enrollment_number: 40,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1012
  }),
  Course.create({
    name: "Data Mining, Neural Networks and Genetic Programming ",
    course_code: "COMP422",
    enrollment_number: 50,
    tutors_required: 4,
    state: :dormant,
    course_coordinator_id: 1013
  }),
  Course.create({
    name: "Directed Individual Study",
    course_code: "COMP440",
    enrollment_number: 30,
    tutors_required: 2,
    state: :dormant,
    course_coordinator_id: 1014
  }),
  Course.create({
    name: "Directed Individual Study",
    course_code: "COMP441",
    enrollment_number: 40,
    tutors_required: 3,
    state: :dormant,
    course_coordinator_id: 1009
  }),
  Course.create({
    name: "Special Topic: Introduction to Big Data Analysis",
    course_code: "COMP473",
    enrollment_number: 90,
    tutors_required: 6,
    state: :dormant,
    course_coordinator_id: 1008
  }),
  Course.create({
    name: "Research Project",
    course_code: "COMP489",
    enrollment_number: 100,
    tutors_required: 5,
    state: :dormant,
    course_coordinator_id: 1007
  })
],



# Hourly Rates
hourly_rates = [
  Admin::HourlyRates.levels.each do |level|
    Admin::HourlyRates.years_experience.each do |years_experience|
      find = Admin::HourlyRates.where(level: level, years_experience: years_experience).first
      unless find.present?
        Admin::HourlyRates.create({
          level: level,
          years_experience: years_experience,
          rate: 15.00
        })
      end
    end
  end
]
