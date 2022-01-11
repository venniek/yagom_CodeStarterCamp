class Person {
    var name: String
    var bodyCondition: BodyCondition

    init (name: String, bodyCondition: BodyCondition) {
        self.name = name
        self.bodyCondition = bodyCondition
    }

    func exercise(for set:Int, routine: Routine) {

    }
}

class FitnessCenter {
    let name: String
    var aimBodyCondition: BodyCondition
    var member: Person?
    var routines = [Routine]()
    var aimInput = [Int]()

    init (name: String = "야곰", aim: BodyCondition, member: Person?, routines: [Routine]) {
        self.name = name
        aimBodyCondition = aim
        self.member = member
        self.routines = routines
    }

    func getIntFromReadLine() -> Int {
        guard let inputInt = Int(getNonOptionalString(readLine())) else {
            return 0
        }
        return inputInt
    }

    func getNonOptionalPerson(_ person: Person?) -> Person {
        guard let nonOptionalPerson = person else {
            return
        }
        return nonOptionalPerson
    }

    func start() {
        var program: Routine
        var howManySet: Int
        var isMemberRun: Bool
        var isDoneWell: Bool

        getMemberName()
        makeAimOfExercise()
        repeat {
            program = selectRoutine()
            howManySet = getSetCount()
            isMemberRun = startProgram(program: program, howManySet: howManySet, person: member!)
            if isMemberRun == true {
                return
            }
            isDoneWell = successToAim(person: member!)
            if isDoneWell == false {
                print("목표치에 도달하지 못했습니다. 현재 \(member?.name ?? "nobody")님의 컨디션은 다음과 같습니다.")
            } else {
                return
            }
        } while isDoneWell == false
    }

    func getMemberName() {
        print("안녕하세요. \(name) 피트니스 센터입니다. 회원님의 이름은 무엇인가요?")
        if let memberName = readLine() { member?.name = memberName }
    }

    func makeAimOfExercise() {
        print("운동 목표치를 순서대로 알려주세요. 상체근력, 하체근력, 근지구력, 한계 피로도 순")
        for _ in 0...3 {
            aimInput.append(getIntFromReadLine())
        }
        aimBodyCondition.upperBodyStrength = aimInput[0]
        aimBodyCondition.lowerBodyStrength = aimInput[1]
        aimBodyCondition.muscularEndurance = aimInput[2]
        aimBodyCondition.fatigue = aimInput[3]
    }

    func selectRoutine() -> Routine {
        print("몇 번째 루틴으로 운동하시겠어요?")
        for count in 0..<routineList.count {
            print("\(count + 1). \(routineList[count].name)")
        }
        return routineList[getIntFromReadLine() - 1]
    }

    func getSetCount() -> Int {
        print("몇 세트 반복하시겠어요?")
        return getIntFromReadLine()
    }

    func startProgram(program: Routine, howManySet: Int, person: Person) -> Bool {
        for count in 1...howManySet {
            print("--------------------------")
            print("\(name) \(count)set 시작합니다.")
            for exercise in program.routines {
                print(exercise.name)
                exercise.action(person.bodyCondition)
                if person.bodyCondition.fatigue > aimBodyCondition.fatigue {
                    print("\(person.name)님의 피로도가 \(person.bodyCondition.fatigue)입니다. 회원님이 도망갔습니다.")
                    return true
                }
            }
            print("성공입니다! 현재 \(person.name)님의 컨디션은 다음과 같습니다.")
            person.bodyCondition.checkCondition()
            print("--------------------------")
        }
        return false
    }

    func successToAim(person: Person) -> Bool {
        if person.bodyCondition.upperBodyStrength < aimBodyCondition.upperBodyStrength {
            return false
        }
        if person.bodyCondition.lowerBodyStrength < aimBodyCondition.lowerBodyStrength {
            return false
        }
        if person.bodyCondition.muscularEndurance < aimBodyCondition.muscularEndurance {
            return false
        }
        return true
    }
}


class BodyCondition {
    var upperBodyStrength: Int
    var lowerBodyStrength: Int
    var muscularEndurance: Int
    var fatigue: Int

    init(upper: Int = 0, lower: Int = 0, muscular: Int = 0, fatigue: Int = 0) {
        upperBodyStrength = upper
        lowerBodyStrength = lower
        muscularEndurance = muscular
        self.fatigue = fatigue
    }

    func checkCondition() {
        print("상체근력: \(upperBodyStrength)\n하체근력: \(lowerBodyStrength)\n근지구력: \(muscularEndurance)\n피로도 : \(fatigue)")
    }

    func randomIntBetween(_ a: Int, _ b: Int) -> Int {
        return Int.random(in: a...b)
    }
}

struct Exercise {
    let name: String
    let action: (BodyCondition) -> Void
}

struct Routine {
    let name: String
    let person: BodyCondition
    let routines: [Exercise]

    init(name: String, person: BodyCondition, routines: [Exercise]) {
        self.name = name
        self.person = person
        self.routines = routines
    }
}
