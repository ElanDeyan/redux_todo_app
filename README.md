# Redux ToDo app

A basic ToDo app to practice and apply [Redux architecture](https://pub.dev/packages/redux).

## How to run this app

To run this app, you should have:

- Flutter installed in your host machine, either Windows, linux or MacOS. (This app was developed in a Windows machine, and was not tested in linux and MacOS environments).

To test if you have flutter installed correctly, open a terminal and type:

```sh
flutter doctor
```

If it's okay, [clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository), open the project's folder in your terminal, then type:

```sh
flutter run --profile
```

The `--profile` will run a profile version of the app, which is closer of the release (public) version, so it has better performance.

You'll be prompted to choose from a set of options (Windows, Chrome, an Android Emulator...). Type the option number acordingly and wait.

## Redux architecture

The redux architecture is based in the following concepts:

- Single source of truth

We have some components of this architecture (considering a UI application with a view):

- app's state
- one Store
- one (or more, combined in one) Reducer
- actions
- middlewares
- view

The following image explains better the relationship between these components:

![Flow chart of redux architecture with a view](https://blog.logrocket.com/wp-content/uploads/2021/10/redux-with-middleware.png)

The `Store` is like a... store that will hold the state of your app. Think the "state of your app" like a piece of information(s) that your app needs to display the data accordingly. I'll show how this works with this app in another section.

So, looking from the point of view of the user, when you access the app, the interface will present information based on the data present in the `State`.

The app will have things, like a button, that, when pressed, they will fire an `Action`. Actions can be understood like intentions, events. They represent something that you want to do, like "Hey, increment this counter" or "Add this todo task".

Alright, so, my `View`, through a button for instance, will fire an `Action`, like add a todo task, but... where was this `Action` fired?

To the `Reducer`. it knows the actual app's state, receives an action and returns an updated version of the state accordingly with the received action. For instance, if I have an empty todo list, and I fire an "Add todo" `Action`, the `Reducer`  will updates the state to it has the added todo.

So, every action is fired to the `Reducer`, and then it goes to the `Store`, right?

Wait! In fact, your dispatched action will be sent to the `Reducer`. You're right! But, we have the `Middleware` component.

`Middleware`'s role is to intercept any fired action and do something with it. Looking to the flowchart above, you can see it lives between the fired `Action` and the `Reducer`. It can, for instance:

- Log the actual state before the action reach the reducer, log the fired action, dispatch the action, and then log the state after the action!
- Write your action data in a database or request an API.
- Change your action, like add a todo in a database and, after successful, fire an "updated" version of this action with the todo with, for instance, an Id.
- Not dispatch this action. Yes, the middleware can simply not dispatch the action.

`Middleware` is powerful! He has access to the `Store`, intercepts `Action`s before they reach the `Reducer` and can dispacth (or not) `Action`s, that can be modified or not!

<!-- Middleware, in terms of code, is asynchronous, what means that -->

Remember that the app needs the State to display the UI accordingly? What if I add the todo, like I said before, but nothing changes the UI? So, that's why the View depends of the state.

When something change in the state, something like this happended:

Store: "Hey View, my State has changed, here's the new value. Update yourself, please?"
View: "Okay, thanks for the advice. Updating!"

Therefore, our app will follow this cycle, depending on the `State`, provided by the `Store`, our app will display whatever it wants, like a todo list. You, the user, want to do something, so, from the UI, you'll fire an `Action`. Yor action will be sent to the reducer, but, the middleware is paying attention and will catch your action before it reaches the reducer. The middleware can do whatever it wants with the action, dispatches, modify then dispatch, not dispatch... If it is dispatched, the action will finally reach the `Reducer`, that will updates the `Store` with a new and updated `State`. Since your app is listening changes in the `State`, when something changes, the `View` will be updated accordingly.
