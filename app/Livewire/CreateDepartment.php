<?php

namespace App\Livewire;

use App\Models\Department;
use Illuminate\View\View;
use Livewire\Attributes\Validate;
use Livewire\Component;

class CreateDepartment extends Component
{
    #[Validate('required|string|max:255')]
    public $name = '';

    public function mount(?int $departmentId = null): void
    {
        if ($departmentId) {
            $this->name = Department::findOrFail($departmentId)->name;
        }
    }

    public function store(): void
    {
        Department::create([
            'name' => $this->name
        ]);
    }

    public function render(): View
    {
        return view('livewire.create-department');
    }
}
