#[starknet::interface]
trait IStudents<TContractState> {
    fn add_student(ref self: TContractState, admission: felt252, student_name: felt252, course: felt252);
    fn get_student(self: @TContractState, admission: felt252) -> Students::Student;
    fn update_student(ref self: TContractState, admission: felt252, student_name: felt252, course: felt252);
    fn delete_student(ref self: TContractState, admission: felt252); 
}

#[starknet::contract]
mod Students {
    use starknet::get_caller_address;
    use starknet::contract_address;

    

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Student {
        admission: felt252,
        student_name: felt252,
        course: felt252,
        in_session: bool,
    }
    

    #[storage]
    struct Storage {
        auto_increment_id: u256,
        registered_students: LegacyMap<felt252, Student>
    }

    impl Studentimpl of super::IStudents<ContractState> {
        fn add_student(ref self: ContractState, admission: felt252, student_name: felt252, course: felt252){
            let mut id = self.auto_increment_id;
            self.registered_students.write(admission, Student {admission: admission, student_name: student_name, course: course, in_session: true});
            self.auto_increment_id.write(self.auto_increment_id.read() + 1);
        }

        fn get_student(self: @ContractState, admission: felt252) -> Student {
            self.registered_students.read(admission)
        }

        fn update_student(ref self:ContractState, admission: felt252, student_name: felt252, course: felt252) {
            self.registered_students.write(admission, Student {admission: admission, student_name: student_name, course: course, in_session: true});
        }

        fn delete_student(ref self: ContractState, admission: felt252){
            let mut student = self.registered_students.read(admission);
            student.in_session = false;
            self.registered_students.write(admission, student);
            self.auto_increment_id.write(self.auto_increment_id.read() - 1);
        }
    }
}