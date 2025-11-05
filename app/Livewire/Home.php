<?php

namespace App\Livewire;

use Illuminate\View\View;
use Livewire\Attributes\Title;
use Livewire\Component;

#[Title('Teamsy | Home')]
class Home extends Component
{
    public function render(): View
    {
        return view('livewire.home');
    }
}
