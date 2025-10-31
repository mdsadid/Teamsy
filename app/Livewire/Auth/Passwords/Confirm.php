<?php

namespace App\Livewire\Auth\Passwords;

use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;
use Livewire\Component;

class Confirm extends Component
{
    /** @var string */
    public $password = '';

    public function confirm(): RedirectResponse
    {
        $this->validate([
            'password' => 'required|current_password',
        ]);

        session()->put('auth.password_confirmed_at', time());

        return redirect()->intended(route('home'));
    }

    public function render(): View
    {
        return view('livewire.auth.passwords.confirm')->extends('layouts.auth');
    }
}
