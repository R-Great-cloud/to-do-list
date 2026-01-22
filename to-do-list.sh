#!/bin/bash

TASK_FILE="tasks.txt"

# Load tasks from file if it exists
if [[ -f $TASK_FILE ]]; then
    mapfile -t lists < "$TASK_FILE"
else
    lists=()
fi

save_tasks() {
    printf "%s\n" "${lists[@]}" > "$TASK_FILE"
}

add_task() {
    echo "Enter Task:"
    read -r newtask
    lists+=("$newtask")
    save_tasks
    echo "New task added: $newtask"
}

display() {
    echo "To-Do List"
    if [[ ${#lists[@]} -eq 0 ]]; then
        echo "No tasks available."
        return
    fi

    for i in "${!lists[@]}"; do
        echo "$((i+1)). ${lists[$i]}"
    done
}

delete_task() {
    display
    echo "Enter task number to delete:"
    read -r del

    if (( del < 1 || del > ${#lists[@]} )); then
        echo "Invalid input"
        return
    fi

    echo "Are you sure you want to delete '${lists[$((del-1))]}'? (yes/no)"
    read -r confirm

    if [[ $confirm == "yes" ]]; then
        unset 'lists[del-1]'
        lists=("${lists[@]}")
        save_tasks
        echo "Task deleted"
    else
        echo "Cancelled"
    fi
}

mark_done() {
    display
    echo "Enter task number to mark as done:"
    read -r num

    if (( num < 1 || num > ${#lists[@]} )); then
        echo "Invalid input"
        return
    fi

    if [[ ${lists[$((num-1))]} != "[DONE]"* ]]; then
        lists[$((num-1))]="[DONE] ${lists[$((num-1))]}"
        save_tasks
        echo "Task marked as done"
    else
        echo "Task already marked as done"
    fi
}

while true; do
    echo
    echo "To-Do List Manager"
    echo "1. Add Task"
    echo "2. Display Tasks"
    echo "3. Delete Task"
    echo "4. Mark Task as Done"
    echo "5. Exit"
    echo "Choose an option:"
    read -r option

    case $option in
        1) add_task ;;
        2) display ;;
        3) delete_task ;;
        4) mark_done ;;
        5) exit ;;
        *) echo "WRONG INPUT" ;;
    esac
done
