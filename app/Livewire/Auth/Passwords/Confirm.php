<?php

namespace App\Livewire\Auth\Passwords;

use Illuminate\View\View;
use Livewire\Attributes\Title;
use Livewire\Component;

#[Title('Teamsy | Confirm your password')]
class Confirm extends Component
{
    /** @var string */
    public $password = '';

    public function confirm(): void
    {
        $this->validate([
            'password' => 'required|current_password',
        ]);

        session()->put('auth.password_confirmed_at', time());

        $this->redirectIntended(route('home'));
    }

    public function render(): View
    {
        return view('livewire.auth.passwords.confirm');
    }
}
