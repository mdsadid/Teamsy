<?php

namespace App\Livewire\Auth;

use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;
use Livewire\Attributes\Title;
use Livewire\Component;

#[Title('Teamsy | Create a new account')]
class Register extends Component
{
    /** @var string */
    public $name = '';

    /** @var string */
    public $email = '';

    /** @var string */
    public $password = '';

    /** @var string */
    public $passwordConfirmation = '';

    public function register(): void
    {
        $this->validate([
            'name'     => ['required'],
            'email'    => ['required', 'email', 'unique:users'],
            'password' => ['required', 'min:8', 'same:passwordConfirmation'],
        ]);

        $user = User::create([
            'email'    => $this->email,
            'name'     => $this->name,
            'password' => $this->password,
        ]);

        event(new Registered($user));

        Auth::login($user, true);

        $this->redirectIntended(route('home'));
    }

    public function render(): View
    {
        return view('livewire.auth.register');
    }
}
