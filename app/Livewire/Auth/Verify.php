<?php

namespace App\Livewire\Auth;

use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;
use Livewire\Component;

class Verify extends Component
{
    public function resend(): void
    {
        if (Auth::user()->hasVerifiedEmail()) {
            redirect(route('home'));
        }

        Auth::user()->sendEmailVerificationNotification();

        $this->dispatch('resent');

        session()->flash('resent');
    }

    public function render(): View
    {
        return view('livewire.auth.verify')->extends('layouts.auth');
    }
}
